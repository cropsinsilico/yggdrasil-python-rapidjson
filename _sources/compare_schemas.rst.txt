===========================
 compare_schemas() function
===========================

.. currentmodule:: yggdrasil_rapidjson

.. testsetup::

   from yggdrasil_rapidjson import compare_schemas

.. function:: compare_schemas(schemaA, schemaB, dont_raise=False)

   Compare two JSON schemas for compatibility.

   :param str, dict schemaA: first JSON schema for comparison
   :param str, dict schemaB: second JSON schema for comparison
   :param bool dont_raise: if True, an error will not be raised if the
                           schemas are incompatible.
   :returns: True if the schemas are compatible, False otherwise.

   .. doctest::

      >>> compare_schemas('{"type": "number"}', '{"type": ["number", "schema"]}')
      True
      >>> compare_schemas({"type": "number"}, {"type": ["number", "schema"]})
      True

   .. _dont_raise:
   .. rubric:: `dont_raise`

   If `dont_raise` is True (default: ``False``), then the comparison will return False when the two schemas are incompatible rather than raising an error.

   .. doctest::

      >>> compare_schemas({"type": "number"}, {"type": "string"}) # doctest: +IGNORE_EXCEPTION_DETAIL
      Traceback (most recent call last):
      ComparisonError: {
          "message": "Incompatible schema property 'type': [\"number\"] vs [\"string\"].",
          "schemaIteratorRef": "#",
          "schemaHandlerRef": "#"
      }
      >>> compare_schemas({"type": "number"}, {"type": "string"}, dont_raise=True)
      False
