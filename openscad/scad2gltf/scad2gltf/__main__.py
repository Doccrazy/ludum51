import sys
import os
import subprocess
from copy import copy
from tempfile import gettempdir
import argparse
import regex as re
from scad2gltf import gltf

def get_openscad_exe():
    """
    This returns the name of the openscad executable. It is needed as OpenSCAD is not
    on the path in MacOS.
    """
    if sys.platform.startswith("darwin"):
        return "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    return "openscad"

def scad2csg(scadfile):
    tmpdir = gettempdir()
    scadfilename = os.path.basename(scadfile)
    csgfilename = scadfilename[:-4] + 'csg'
    csgfile = os.path.join(tmpdir, csgfilename)
    executable = get_openscad_exe()
    subprocess.run([executable] + [scadfile, '-o', csgfile], check=True)
    return csgfile

def csg_split_by_colour(csgfile):
    with open(csgfile, 'r') as file:
        csg = file.read()
    matches = [i for i in re.finditer(r'(color\((\[[0-9\.]+(?: *, *?[0-9\.]+)*\])\) *(\{(?:[^{}]*(?3)?)*+\}))', csg)]
    filenames = []
    colours = []
    for i, match in enumerate(matches):
        csg_cpy = copy(csg)
        name = f"group_{i}_colour_{match.group(2)}.csg"
        colour_str = match.group(2)[1:-1]
        colour = [float(j) for j in colour_str.split(',')]
        filenames.append(name)
        colours.append(colour)
        #Loop over other matches in reverse so ranges arent affected
        for other_match in reversed([m for j, m in enumerate(matches) if j!=i]):
            span = other_match.span()
            csg_cpy = csg_cpy[0:span[0]] + csg_cpy[span[1]+1:]
        with open(name, 'w') as file_out:
            file_out.write(csg_cpy)
    return filenames, colours

def csg2stl(csgfile):
    print(f'*\n*\nProcessing "{csgfile}"\n*\n*')
    tmpdir = gettempdir()
    stlfile = os.path.join(tmpdir, csgfile[:-3] + 'stl')
    executable = get_openscad_exe()
    subprocess.run([executable] + [csgfile, '-o', stlfile], check=True)
    os.remove(csgfile)
    return stlfile

def main():
    """This is what runs if you run `KitDex` from the terminal
    To run from inside python use `run_kitex`
    """

    parser = argparse.ArgumentParser(description='Convert .scad file into .gltf')
    parser.add_argument('scadfile',
                        help='Path of the .scad file')
    args = parser.parse_args()

    csgfile = scad2csg(args.scadfile)
    split_csgs, colours = csg_split_by_colour(csgfile)
    stls = []
    for colour_csg in split_csgs:
        stls.append(csg2stl(colour_csg))
    gltffile = args.scadfile[:-4] + 'glb'
    gltf.stls2gltf(stls, colours, gltffile)
