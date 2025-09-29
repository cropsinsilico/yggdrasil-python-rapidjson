=================
 Normalizer class
=================

.. currentmodule:: yggdrasil_rapidjson

.. testsetup::

   from yggdrasil_rapidjson import NormalizationError, Normalizer

.. class:: Normalizer(json_schema)

   :param json_schema: the `JSON schema`__, specified as a ``str`` instance or an *UTF-8*
                       :class:`bytes`/:class:`bytearray` instance
   :raises JSONDecodeError: if `json_schema` is not a valid ``JSON`` value

   __ http://json-schema.org/documentation.html

   .. method:: __call__(json)

      :param json: the ``JSON`` value, specified as a ``str`` instance or an *UTF-8*
                   :class:`bytes`/:class:`bytearray` instance, that will be normalized
      :raises JSONDecodeError: if `json` is not a valid ``JSON`` value

      The given `json` value will be normalized accordingly to the *schema* and returned: a
      :exc:`NormalizationError` will be raised if the normalization fails, and the exception
      will contain three arguments, respectively the type of the error, the position in
      the schema and the position in the ``JSON`` document where the error occurred:

      .. doctest::

         >>> normalize = Normalizer('{"required": ["a", "b"], "properties": {"b": {"default": 1.0}}}')
         >>> normalize('{"a": null}')
         {'a': None, 'b': 1.0}
         >>> try:
         ...   normalize('{"c": false}')
         ... except NormalizationError as error:
         ...   print(error.args)
         ...
	 ('{\n    "message": "Object is missing the following members required by the schema: \'[\\"a\\"]\'.",\n    "instanceRef": "#",\n    "schemaRef": "#"\n}',)

      .. doctest::

         >>> import numpy as np
         >>> normalize = Normalizer({"type": "array",
         ...                         "items": {"type": "scalar",
         ...                                   "subtype": "int",
         ...                                   "precision": 8},
         ...                         "minItems": 1})
         >>> normalize([1.0, np.uint32(5)])
         [1, 5]
         >>> try:
         ...   normalize([3.2])
         ... except NormalizationError as error:
         ...   print(error.args)
         ...
	 ('{\n    "message": "Property has a subtype \'float\' that is not in the following list \'[\\"int\\"]\'.",\n    "instanceRef": "#/0",\n    "schemaRef": "#/items"\n}',)
