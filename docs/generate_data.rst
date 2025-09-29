=========================
 generate_data() function
=========================

.. currentmodule:: yggdrasil_rapidjson

.. testsetup::

   from yggdrasil_rapidjson import generate_data

.. function:: generate_data(schema)

   Generate data that conforms to the provided schema.

   :param str, dict: JSON schema to generate data for
   :returns: Python object that conforms to the provided schema

   .. doctest::

      >>> generate_data('{"type": "number"}')
      0.0
      >>> generate_data({"type": "object", "properties": {"a": {"type": "integer"}}})
      {'a': 0}
      >>> generate_data({"type": "ndarray", "subtype": "complex"})
      array([[0.+0.j, 0.+0.j],
             [0.+0.j, 0.+0.j]])
