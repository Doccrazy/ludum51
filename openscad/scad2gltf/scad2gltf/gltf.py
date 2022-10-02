'''
This is adapted from:
https://stackoverflow.com/questions/66341118/how-do-i-import-an-stl-into-pygltflib
'''

import pygltflib
import numpy as np
from stl import mesh


def stl2mesh(stlfile):
    stl_mesh = mesh.Mesh.from_file(stlfile)

    stl_points = []
    for i in range(0, len(stl_mesh.points)): # Convert points into correct numpy array
        stl_points.append([stl_mesh.points[i][0],stl_mesh.points[i][1],stl_mesh.points[i][2]])
        stl_points.append([stl_mesh.points[i][3],stl_mesh.points[i][4],stl_mesh.points[i][5]])
        stl_points.append([stl_mesh.points[i][6],stl_mesh.points[i][7],stl_mesh.points[i][8]])

    points = np.array(
        stl_points,
        dtype="float32",
    )

    stl_normals = []
    for normal in stl_mesh.normals:
        magnitude = np.sqrt(np.sum(normal**2))
        if magnitude<1e-10:
            #Give zero magnitude elements and aribary unit vector to keep GLTF format happy
            normal_vector = np.asarray([1,0,0])
        else:
            normal_vector = normal/magnitude
        stl_normals.append(normal_vector)
        stl_normals.append(normal_vector)
        stl_normals.append(normal_vector)

    normals = np.array(
        stl_normals,
        dtype="float32"
    )
    return points, normals


def stls2gltf(stlfiles, colours, gltffile):

    nodes = []
    node_numbers = []
    meshes = []
    bufferviews = []
    accessors = []
    materials = []
    running_buffer_len=0
    blob = None

    for i, stlfile in enumerate(stlfiles):
        points, normals = stl2mesh(stlfile)
        points_binary_blob = points.tobytes()
        normals_binary_blob = normals.tobytes()

        points_buf_no = 2*i
        normal_buf_no = points_buf_no+1

        node_numbers.append(i)
        nodes.append(pygltflib.Node(mesh=i))

        attribute = pygltflib.Attributes(POSITION=points_buf_no, NORMAL=normal_buf_no)
        primitive = pygltflib.Primitive(attributes=attribute, indices=None, material=i)
        meshes.append(pygltflib.Mesh(primitives=[primitive]))

        pbr_metal = pygltflib.PbrMetallicRoughness(baseColorFactor = colours[i])
        material = pygltflib.Material(pbrMetallicRoughness=pbr_metal,
                                      name=f"color{i}")
        materials.append(material)

        points_accessor = pygltflib.Accessor(bufferView=points_buf_no,
                                             componentType=pygltflib.FLOAT,
                                             count=len(points),
                                             type=pygltflib.VEC3,
                                             max=points.max(axis=0).tolist(),
                                             min=points.min(axis=0).tolist())
        normals_accessor = pygltflib.Accessor(bufferView=normal_buf_no,
                                              componentType=pygltflib.FLOAT,
                                              count=len(normals),
                                              type=pygltflib.VEC3,
                                              max=None,
                                              min=None)
        accessors.append(points_accessor)
        accessors.append(normals_accessor)

        points_buffer = pygltflib.BufferView(buffer=0,
                                             byteOffset=running_buffer_len,
                                             byteLength=len(points_binary_blob),
                                             target=pygltflib.ARRAY_BUFFER)
        running_buffer_len += len(points_binary_blob)
        normals_buffer = pygltflib.BufferView(buffer=0,
                                              byteOffset=running_buffer_len,
                                              byteLength=len(normals_binary_blob),
                                              target=pygltflib.ARRAY_BUFFER)
        running_buffer_len += len(normals_binary_blob)
        bufferviews.append(points_buffer)
        bufferviews.append(normals_buffer)

        if blob is None:
            blob = points_binary_blob
        else:
            blob += points_binary_blob
        blob += normals_binary_blob


    gltf = pygltflib.GLTF2(
        scene=0,
        scenes=[pygltflib.Scene(nodes=node_numbers)],
        nodes=nodes,
        meshes=meshes,
        materials=materials,
        accessors=accessors,
        bufferViews=bufferviews,
        buffers=[pygltflib.Buffer(byteLength=running_buffer_len)],
    )
    gltf.set_binary_blob(blob)
    gltf.save(gltffile)
