========
Geometry
========

YggdrasilRapidJSON_ added support for passing 3D meshes in JSON documents as encoded strings. The ``yggdrasil_rapidjson.geometry`` submodule wraps the YggdrasilRapidJSON_ geometry classes.

ObjWavefront
------------

.. doctest::

   >>> from yggdrasil_rapidjson import geometry
   >>> import numpy as np
   >>> vertices = np.array([[0, 0, 0, 0, 1, 1, 1, 1],
   ...                      [0, 0, 1, 1, 0, 0, 1, 1],
   ...                      [0, 1, 1, 0, 0, 1, 1, 0]], 'float32').T
   >>> faces = np.array([[0, 0, 7, 0, 1, 2, 3],
   ...                   [1, 2, 6, 4, 5, 6, 7],
   ...                   [2, 3, 5, 5, 6, 7, 4]], 'int32').T
   >>> x = geometry.Ply(vertices, faces)
   >>> str(x)
   'ply\nformat ascii 1.0\nelement vertex 8\nproperty float x\nproperty float y\nproperty float z\nelement face 7\nproperty list uchar int vertex_index\nend_header\n0 0 0\n0 0 1\n0 1 1\n0 1 0\n1 0 0\n1 0 1\n1 1 1\n1 1 0\n3 0 1 2\n3 0 2 3\n3 7 6 5\n3 0 4 5\n3 1 5 6\n3 2 6 7\n3 3 7 4\n'

Ply
---

.. doctests::

   >>> y = geometry.ObjWavefront(vertices, faces)
   >>> str(y)
   'v 0.0 0.0 0.0\nv 0.0 0.0 1.0\nv 0.0 1.0 1.0\nv 0.0 1.0 0.0\nv 1.0 0.0 0.0\nv 1.0 0.0 1.0\nv 1.0 1.0 1.0\nv 1.0 1.0 0.0\nf 1 2 3\nf 1 3 4\nf 8 7 6\nf 1 5 6\nf 2 6 7\nf 3 7 8\nf 4 8 5\n'

.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
