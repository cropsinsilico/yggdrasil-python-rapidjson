========================
 as_pure_json() function
========================

.. currentmodule:: yggdrasil_rapidjson

.. testsetup::

   from yggdrasil_rapidjson import as_pure_json, units

.. function:: as_pure_json(json)

   Convert a JSON document containing yggdrasil extension values to pure JSON. This can result in the loss of information that cannot be expressed in pure JSON (e.g. units, value precision, complex numbers)

   :param str, dict as_pure_json: JSON document to convert to a pure JSON instance
   :returns: Converted docuemnt.

   .. doctest::

      >>> as_pure_json(3.2+4.1j)
      [3.2, 4.1]
      >>> as_pure_json(units.Quantity(5, 'cm'))
      5
      >>> import numpy as np
      >>> as_pure_json(np.arange(4))
      [0, 1, 2, 3]
