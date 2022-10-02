'''Setup for the module'''

__author__ = 'Julian Stirling'
__version__ = '0.0.1'

import sys
from os import path
from setuptools import setup, find_packages

def install():
    '''The installer'''

    if sys.version_info[0] == 2:
        sys.exit("Sorry, Python 2 is not supported")

    this_directory = path.abspath(path.dirname(__file__))
    with open(path.join(this_directory, 'README.md'), encoding='utf-8') as file_id:
        long_description = file_id.read()
    short_description = ('Create GLTF files from OpenSCAD files.')

    setup(name='scad2gltf',
          version=__version__,
          license="GPLv3",
          description=short_description,
          long_description=long_description,
          long_description_content_type='text/markdown',
          author=__author__,
          author_email='julian@julianstirling.co.uk',
          packages=find_packages(),
          keywords=['OpenSCAD', 'Linting'],
          zip_safe=False,
          url='https://gitlab.com/bath_open_instrumentation_group/scad2gltf',
          project_urls={"Bug Tracker": "https://gitlab.com/bath_open_instrumentation_group/scad2gltf/issues",
                        "Source Code": "https://gitlab.com/bath_open_instrumentation_group/scad2gltf"},
          classifiers=['Development Status :: 5 - Production/Stable',
                       'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
                       'Programming Language :: Python :: 3.6'],
          install_requires=['numpy', 'numpy-stl', 'pygltflib', 'regex'],
          python_requires=">=3.6",
          entry_points={'console_scripts': ['scad2gltf = scad2gltf.__main__:main']})

if __name__ == "__main__":
    install()
