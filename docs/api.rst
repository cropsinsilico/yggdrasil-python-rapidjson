===============================
 Exposed functions and symbols
===============================

.. currentmodule:: yggdrasil_rapidjson

.. toctree::
   :maxdepth: 2

   units
   geometry
   validator
   normalizer
   encode_schema
   compare_schemas
   generate_data
   as_pure_json

.. data:: __author__

   The authors of the module.

.. data:: __version__

   The version of the module.

.. data:: __rapidjson_version__

   The version of the YggdrasilRapidJSON_ library this module is built with.

.. data:: __rapidjson_exact_version__

   The *exact* version of the YggdrasilRapidJSON library, as determined by ``git describe``.

.. rubric:: `yggdrasil_mode` related constants

.. data:: YM_BASE64

   This is the default `yggdrasil_mode`: :func:`dumps` and :func:`loads` handle YggdrasilRapidJSON extension types as strings with a schema header using base64 encoding.

.. data:: YM_READABLE

   In this `yggdrasil_mode` mode :func:`dumps` and :func:`loads` handle YggdrasilRapidJSON extension types as human readable JSON documents.

.. data:: YM_PICKLE

   In this `yggdrasil_mode` mode :func:`dumps` and :func:`loads` will pickle/unpickle unsupported Python objects.


.. rubric:: Exceptions

.. exception:: NormalizationError

   Exception raised by :class:`Normalizer` objects, a subclass of :exc:`ValueError`.

   Its `args` attribute is a tuple with three string values, respectively the *schema
   keyword* that generated the failure, its *JSON pointer* and a *JSON pointer* to the
   error location in the (invalid) document.

.. exception:: ComparisonError

.. exception:: GenerateError

.. rubric:: Warnings

.. exception:: ValidationWarning

.. exception:: NormalizationWarning


.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
.. _ISO 8601: https://en.wikipedia.org/wiki/ISO_8601
.. _RapidJSON: http://rapidjson.org/
.. _UTC: https://en.wikipedia.org/wiki/Coordinated_Universal_Time
.. _Unix time: https://en.wikipedia.org/wiki/Unix_time
