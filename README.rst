
===========================
 yggdrasil-python-rapidjson
===========================

Python wrapper around YggdrasilRapidJSON
========================================

:Authors: Meagan Lang <langmm.astro@gmail.com>; Ken Robbins [RapidJSON] <ken@kenrobbins.com>; Lele Gaifax [RapidJSON] <lele@metapensiero.it>
:License: `MIT License <https://raw.githubusercontent.com/cropsinsilico/yggdrasil-python-rapidjson/yggdrasil/LICENSE>`_

YggdrasilRapidJSON_ is an extension to RapidJSON_, an extremely fast C++ JSON parser and serialization library. This package
wraps it into a Python C-extension, duplicating the functions/classes provided by `python-rapidjson <https://github.com/python-rapidjson/python-rapidjson>`_ and exposing the features added by YggdrasilRapidJSON_ including serialization/deserialization of additional datatypes, unitful scalars/arrays, and schema normalization/comparison.

.. TODO: Documentation link
.. TODO: https://python-rapidjson.readthedocs.io/en/latest


Getting Started
---------------

First install ``yggdrasil-python-rapidjson``:

.. code-block:: bash

    $ pip install yggdrasil-python-rapidjson

or, if you prefer `Conda <https://conda.io/docs/>`_ (NOTE: the conda-forge feedstock for ``yggdrasil-python-rapidjson`` is not yet available, but will be once the PR is merged):

.. code-block:: bash

    $ conda install -c conda-forge yggdrasil-python-rapidjson

Basic usage looks the same as python-rapidjson, with the exception of the package name (example adapted from python-rapidjson README.rst):

.. code-block:: python

    >>> import yggdrasil_rapidjson
    >>> data = {'foo': 100, 'bar': 'baz'}
    >>> yggdrasil_rapidjson.dumps(data)
    '{"foo":100,"bar":"baz"}'
    >>> yggdrasil_rapidjson.loads('{"bar":"baz","foo":100}')
    {'bar': 'baz', 'foo': 100}
    >>>
    >>> class Stream:
    ...   def write(self, data):
    ...      print("Chunk:", data)
    ...
    >>> yggdrasil_rapidjson.dump(data, Stream(), chunk_size=5)
    Chunk: b'{"foo'
    Chunk: b'":100'
    Chunk: b',"bar'
    Chunk: b'":"ba'
    Chunk: b'z"}'


Development
-----------

If you want to install the development version (maybe to contribute fixes or
enhancements) you may clone the repository:

.. code-block:: bash

    $ git clone https://github.com/cropsinsilico/yggdrasil-python-rapidjson.git

The package can be built and installed from source via

.. code-block:: bash

    $ pip install .

.. note:: The install command will clone a copy of the YggdrasilRapidJSON_
          sources as part of the build process if an existing
          YggdrasilRapidJSON installation cannot be found (in the usual
          locations checked by cmake for your OS).

          Alternatively, if you already have a (*compatible*) local copy of the 
          YggdrasilRapidJSON repository around, you can compile the module specifying
          their location with the option ``--config-settings=cmake.define.YGGDRASIL_RAPIDJSON_REPO_DIR=``, for example:

          .. code-block:: shell

             $ pip install . --config-settings=cmake.define.YGGDRASIL_RAPIDJSON_REPO_DIR=/usr/local/yggdrasil-rapidjson

The package tests and doctests can be run via pytest

.. code-block:: bash

    $ python -m pytest tests/ --doctest-glob="docs/*.rst" --doctest-modules docs

    
.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
.. _RapidJSON: http://rapidjson.org/
.. _PythonRapidJSON: https://github.com/python-rapidjson/python-rapidjson
