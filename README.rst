
===========================
 yggdrasil-python-rapidjson
===========================

Python wrapper around YggdrasilRapidJSON
========================================

:Authors: Meagan Lang <langmm.astro@gmail.com>; Ken Robbins [RapidJSON] <ken@kenrobbins.com>; Lele Gaifax [RapidJSON] <lele@metapensiero.it>
:License: `MIT License <https://raw.githubusercontent.com/cropsinsilico/yggdrasil-python-rapidjson/yggdrasil/LICENSE>`_

YggdrasilRapidJSON_ is an extension to RapidJSON_, an extremely fast C++ JSON parser and serialization library. This package
wraps it into a Python C-extension, duplicating the functions/classes provided by `python-rapidjson <https://github.com/python-rapidjson/python-rapidjson>`_ and exposing the features added by YggdrasilRapidJSON_ including serialization/deserialization of additional datatypes, unitful scalars/arrays, and schema normalization/comparison.

Additional information about this package and the ways it extends python-rapidjson can be found in the `yggdrasil-python-rapidjson documentation <https://cropsinsilico.github.io/yggdrasil-python-rapidjson/>`_ while information on the base python-rapidjson classes and methods can be found in the `python-rapidjson documentation <https://python-rapidjson.readthedocs.io/en/latest>`_.


Getting Started
---------------

First install ``yggdrasil-python-rapidjson``:

.. code-block:: bash

    $ pip install yggdrasil-python-rapidjson

or, if you prefer `Conda <https://conda.io/docs/>`_:

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

    $ git clone --recursive https://github.com/cropsinsilico/yggdrasil-python-rapidjson.git

.. note:: The ``--recursive`` option is needed because we use a *submodule* to
          include YggdrasilRapidJSON_ sources. Alternatively you can do a plain
          ``clone`` immediately followed by a ``git submodule update --init``.

          Alternatively, if you already have (a *compatible* version of)
          YggdrasilRapidJSON includes around, you can compile the module specifying
          their location with the option ``--config-settings=cmake.define.RAPIDJSON_INCLUDE_DIRS=``, for example:

          .. code-block:: shell

             $ pip install . --config-settings=cmake.define.RAPIDJSON_INCLUDE_DIRS=/usr/include/rapidjson

The package can be built and installed from source via

.. code-block:: bash

    $ pip install .

The package tests and doctests can be run via pytest

.. code-block:: bash

    $ python -m pytest tests/ --doctest-glob="docs/*.rst" --doctest-modules docs


Maintenance
-----------

Releases
========

The steps below outline how a release should be produced.

1. Complete developments desired for the release and merge them via pull request into the default branch (yggdrasil) after all tests pass. Ensure this includes any upstream changes from python-rapidjson.
2. Create a new branch with the name of the version with a "v" prefix (i.e. vMAJOR.MINOR.PATCH.EXTEN) by either incrementing the EXTEN version or restarting it at 0 if the upstream python-rapidjson version has been incremented.
3. Update CHANGES.rst with release notes and commit them to the version branch.
4. Update the version in the following files and commit them to the version branch.
   * CMakeLists.txt (for docs build)
   * recipe/meta.yaml
   * conda.recipe/recipe.yaml
   * docs/conf.py
5. Merge the version branch via pull request, ensuring that all tests pass.
6. Create an annotated tag for the merged version changes and push it.
   * `git tag -a vX.X.X.X -m "Release vX.X.X.X"`
   * `git push origin --tags`
7. Create a release on github
8. Verify that wheels were pushed to PyPI
9. Ensure the conda feedstock is updated

Publishing the docs
===================

The docs should be automatically be built and published any time a
tag is pushed, but they can be built & published manually by pushing
to the gh-pages branch as below.

```
mkdir build_docs
cd build_docs
cmake .. -DPYRJ_BUILD_DOCS_FOR_PUBLISH=ON
cmake --build .
cd docs/html
git add -A
git commit -m "Updated docs"
git push origin gh-pages
```
    
.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
.. _RapidJSON: http://rapidjson.org/
.. _PythonRapidJSON: https://github.com/python-rapidjson/python-rapidjson
