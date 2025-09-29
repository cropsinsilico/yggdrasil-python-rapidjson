.. -*- coding: utf-8 -*-
.. :Project:   python-rapidjson -- Quickstart examples
.. :Author:    Lele Gaifax <lele@metapensiero.it>
.. :License:   MIT License
.. :Copyright: © 2016, 2017, 2018, 2020, 2021, 2025 Lele Gaifax
..

=============
 Quick start
=============

This a quick overview of the module adapted from the `python-rapidjson quickstart documentation <https://python-rapidjson.readthedocs.io/en/latest/quickstart.html>`_.


Installation
------------

First install ``yggdrasil-python-rapidjson``:

.. code-block:: bash

    $ pip install yggdrasil-python-rapidjson

If possible this installs a *binary wheel*, containing the latest version of the package
already compiled for your system.  Otherwise it will download a *source distribution* and
will try to compile it: as the module is written in C++, in this case you most probably
will need to install a minimal C++ compiler toolchain on your system.

Alternatively it is also possible to install it using `Conda`__.

__ https://anaconda.org/conda-forge/yggdrasil-python-rapidjson


Basic examples
--------------

``yggdrasil-python-rapidjson`` makes use of the ``python-rapidjson`` method wrappers that try to be compatible with the standard library ``json.dumps()`` and
``json.loads()`` functions.

Basic usage looks like this (adapted from the python-rapidjson documentation):

.. doctest::

    >>> from pprint import pprint
    >>> from yggdrasil_rapidjson import dumps, loads
    >>> data = {'foo': 100, 'bar': 'baz'}
    >>> dumps(data, sort_keys=True) # for doctest
    '{"bar":"baz","foo":100}'
    >>> pprint(loads('{"bar":"baz","foo":100}'))
    {'bar': 'baz', 'foo': 100}

All JSON_ data types are supported using their native Python counterparts:

.. doctest::

    >>> int_number = 42
    >>> float_number = 1.4142
    >>> string = "√2 ≅ 1.4142"
    >>> false = False
    >>> true = True
    >>> null = None
    >>> array = [int_number, float_number, string, false, true, null]
    >>> an_object = {'int': int_number, 'float': float_number,
    ...              'string': string,
    ...              'true': true, 'false': false,
    ...              'array': array }
    >>> pprint(loads(dumps({'object': an_object})))
    {'object': {'array': [42, 1.4142, '√2 ≅ 1.4142', False, True, None],
                'false': False,
                'float': 1.4142,
                'int': 42,
                'string': '√2 ≅ 1.4142',
                'true': True}}

Python's lists, tuples and iterators get serialized as JSON arrays:

.. doctest::

    >>> names_t = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')
    >>> names_l = list(names_t)
    >>> names_i = iter(names_l)
    >>> def names_g():
    ...     for name in names_t:
    ...         yield name
    >>> dumps(names_t) == dumps(names_l) == dumps(names_i) == dumps(names_g())
    True

From ``python-rapidjson``, ``yggdrasil-python-rapidjson`` can also handle some other commonly used data types (e.g. :class:`bytes`, :class:`datetime.datetime`, :class:`uuid.UUID`, :class:`decimal.Decimal`). ``yggdrasil-python-rapidjson`` adds support for some additional types including `numpy <https://numpy.org/>`_ arrays, `pandas <https://pandas.pydata.org/>`_ dataframes, Python classes, Python functions, and the added wrapper classes for the YggdrasilRapidJSON_ extension types (``yggdrasil_rapidjson.units.Quantity``, ``yggdrasil_rapidjson.units.QuantityArray``, ``yggdrasil_rapidjson.geometry.Ply``, ``yggdrasil_rapidjson.geometry.ObjWavefront``):

.. doctest::

    >>> import numpy as np
    >>> import pandas as pd
    >>> from yggdrasil_rapidjson import units, geometry
    >>> some_array = np.array([[0, 1, 2, 3], [4, 5, 6, 7]], dtype='int8')
    >>> dumps(some_array)
    '"-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJpbnQiLCJwcmVjaXNpb24iOjEsInNoYXBlIjpbMiw0XX0=-YGG-AAECAwQFBgc=-YGG-"'
    >>> as_json = _
    >>> pprint(loads(as_json))
    array([[0, 1, 2, 3],
           [4, 5, 6, 7]], dtype=int8)
    >>> some_structured_array = np.array([('Rex', 9, 81.0), ('Fido', 3, 27.0)], dtype=[('name', 'U10'), ('age', 'i4'), ('weight', 'f4')])
    >>> dumps(some_structured_array)
    '["-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJzdHJpbmciLCJwcmVjaXNpb24iOjQwLCJzaGFwZSI6WzJdLCJlbmNvZGluZyI6IlVDUzQiLCJ0aXRsZSI6Im5hbWUifQ==-YGG-UgAAAGUAAAB4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEYAAABpAAAAZAAAAG8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=-YGG-","-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJpbnQiLCJwcmVjaXNpb24iOjQsInNoYXBlIjpbMl0sInRpdGxlIjoiYWdlIn0=-YGG-CQAAAAMAAAA=-YGG-","-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJmbG9hdCIsInByZWNpc2lvbiI6NCwic2hhcGUiOlsyXSwidGl0bGUiOiJ3ZWlnaHQifQ==-YGG-AACiQgAA2EE=-YGG-"]'
    >>> as_json = _
    >>> pprint(loads(as_json))
    array([('Rex', 9, 81.), ('Fido', 3, 27.)],
          dtype=[('name', '<U10'), ('age', '<i4'), ('weight', '<f4')])
    >>> some_dataframe = pd.DataFrame(some_structured_array)
    >>> dumps(some_dataframe)
    '["-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJzdHJpbmciLCJwcmVjaXNpb24iOjE2LCJzaGFwZSI6WzJdLCJlbmNvZGluZyI6IlVDUzQiLCJ0aXRsZSI6Im5hbWUifQ==-YGG-UgAAAGUAAAB4AAAAAAAAAEYAAABpAAAAZAAAAG8AAAA=-YGG-","-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJpbnQiLCJwcmVjaXNpb24iOjQsInNoYXBlIjpbMl0sInRpdGxlIjoiYWdlIn0=-YGG-CQAAAAMAAAA=-YGG-","-YGG-eyJ0eXBlIjoibmRhcnJheSIsInN1YnR5cGUiOiJmbG9hdCIsInByZWNpc2lvbiI6NCwic2hhcGUiOlsyXSwidGl0bGUiOiJ3ZWlnaHQifQ==-YGG-AACiQgAA2EE=-YGG-"]'
    >>> as_json = _
    >>> pprint(loads(as_json))
    array([('Rex', 9, 81.), ('Fido', 3, 27.)],
          dtype=[('name', '<U4'), ('age', '<i4'), ('weight', '<f4')])
    >>> some_speed = units.Quantity(3.2, 'cm/s')
    >>> dumps({'a speed': some_speed})
    '{"a speed":"-YGG-eyJ0eXBlIjoic2NhbGFyIiwic3VidHlwZSI6ImZsb2F0IiwicHJlY2lzaW9uIjo4LCJ1bml0cyI6ImNtKihzKiotMSkifQ==-YGG-mpmZmZmZCUA=-YGG-"}'
    >>> as_json = _
    >>> pprint(loads(as_json))
    {'a speed': Quantity(3.2, 'cm*(s**-1)')}
    >>> vertices = np.array([[0, 0, 0, 0], [0, 0, 1, 1], [0, 1, 1, 0]])
    >>> faces =  np.array([[0, 0], [1, 2], [2, 3]])
    >>> some_geometry = geometry.ObjWavefront()
    >>> some_geometry.add_elements('vertices', vertices)
    >>> some_geometry.add_elements('faces', faces)
    >>> dumps(some_geometry)
    '"-YGG-eyJ0eXBlIjoib2JqIn0=-YGG-diAwLjAgMC4wIDAuMCAwLjAKdiAwLjAgMC4wIDEuMCAxLjAKdiAwLjAgMS4wIDEuMCAwLjAKZiAxIDEKZiAyIDMKZiAzIDQK-YGG-"'
    >>> as_json = _
    >>> pprint(loads(as_json)) # doctest: +ELLIPSIS
    <yggdrasil_rapidjson.geometry.ObjWavefront object at ...>

.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
.. _JSON: https://www.json.org/
.. _RapidJSON: http://rapidjson.org/
