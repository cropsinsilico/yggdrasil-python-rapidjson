=====
Units
=====

YggdrasilRapidJSON_ added support for attaching units to scalars and arrays that can be tracked during arithmetic operations. The ``yggdrasil_rapidjson.units`` submodule wraps the YggdrasilRapidJSON_ units classes. Unit expressions are parsed from provided strings. Available units and expression can be found in the `YggdrasilRapidJSON documentation <TODO>`_. Both the scalar (``yggdrasil_rapidjson.units.Quantity``) and array classes (``yggdrasil_rapidjson.units.QuantityArray``) are built on Numpy arrays and can be used with Numpy methods in the ways that Numpy arrays can including `Numpy ufuncs`_.

Scalars
-------

Scalar unit quantities can be created from built-in number classes

.. doctest::

   >>> from yggdrasil_rapidjson import units
   >>> x = units.Quantity(5, 'cm')

or numpy scalars

.. doctest::

   >>> import numpy as np
   >>> y = units.Quantity(np.int8(3), 's')


Arrays
------

Array unit quantities can be created from lists or numpy arrays

.. doctest::

   >>> xarr = units.QuantityArray([1, 2, 3, 4], 'cm')


or numpy arrays

.. doctest::

   >>> import numpy as np
   >>> yarr = units.QuantityArray(np.ones((3, 3), dtype='int8'), 's')


Operations
----------

Arithmetic operations can be performed between quantities and scalars,

.. doctest::

   >>> 3 * x
   Quantity(15, 'cm')
   >>> x / 3
   Quantity(1.66666667, 'cm')
   >>> x % 2
   Quantity(1, 'cm')
   >>> y**2
   Quantity(9, dtype=int8, units='s**2')

between quantities and other quantities,

.. doctest::

   >>> x * y
   Quantity(15, 'cm*s')
   >>> x / y
   Quantity(1.66666667, 'cm*(s**-1)')
   >>> x / units.Quantity(4, 'm')
   Quantity(0.0125, '')
   >>> x + units.Quantity(4, 'mm')
   Quantity(5.4, 'cm')

between quantity arrays and scalars or arrays with the same shape,

.. doctest::

   >>> 3 * xarr
   QuantityArray([ 3,  6,  9, 12], 'cm')
   >>> xarr % 2
   QuantityArray([1, 0, 1, 0], 'cm')
   >>> yarr**2
   QuantityArray([[1, 1, 1],
          [1, 1, 1],
          [1, 1, 1]], dtype=int8, units='s**2')
   >>> xarr * np.array([0.1, 0.4, 2.0, 0.0])
   QuantityArray([0.1, 0.8, 6. , 0. ], 'cm')

between quantity arrays and quantity scalars

.. doctest::

   >>> xarr * x
   Quantity([ 5, 10, 15, 20], 'cm**2')
   >>> xarr / y
   Quantity([0.33333333, 0.66666667, 1.        , 1.33333333], 'cm*(s**-1)')
   >>> xarr % x
   Quantity([1, 2, 3, 4], 'cm')

and between quantity arrays of the same shape

.. doctest::

   >>> xarr / yarr # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   ValueError: operands could not be broadcast together with shapes (4,) (3,3)
   >>> xarr / (0.3 * np.ones((4, )))
   QuantityArray([ 3.33333333,  6.66666667, 10.        , 13.33333333], 'cm')
   >>> xarr / units.QuantityArray(np.ones((4, )), 'kg')
   QuantityArray([1., 2., 3., 4.], 'cm*(kg**-1)')

Some operations are only valid between quantities with compatible units. If the units are not compatible, a ``yggdrasil_rapidjson.units.UnitsError`` will be raised.

.. doctest::

   >>> x + 2 # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   UnitsError: Incompatible units: '' and 'cm'
   >>> x + units.Quantity(2, 'mm')
   Quantity(5.2, 'cm')
   >>> x + y # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   UnitsError: Incompatible units: 's' and 'cm'
   >>> x % y # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   UnitsError: Incompatible units: 's' and 'cm'

`Numpy ufuncs`_ can also be used on both scalar and array quantities

.. doctest::

   >>> np.sqrt(x)
   Quantity(2.23606798, 'cm**0.5')
   >>> np.sqrt(xarr)
   QuantityArray([1.        , 1.41421356, 1.73205081, 2.        ], 'cm**0.5')
   >>> np.power(x, 1.5)
   Quantity(11.18033989, 'cm**1.5')
   >>> np.abs(x)
   Quantity(5, 'cm')
   >>> np.sign(x)
   1
   >>> np.reciprocal(x)
   Quantity(0, 'cm**-1')


Trigonometric functions are only valid on quantities that have angular units. Inverse trigonometric functions are only valid on quantities that are dimensionless.

.. doctest::

   >>> np.sin(x) # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   UnitsError: Incompatible units: 'cm' and 'rad'
   >>> np.sin(units.Quantity(np.pi / 2, 'radians'))
   Quantity(1., '')
   >>> np.cos(units.Quantity(180, 'degrees'))
   Quantity(-1., '')
   >>> np.arccos(x) # doctest: +IGNORE_EXCEPTION_DETAIL
   Traceback (most recent call last):
   UnitsError: Incompatible units: 'cm' and ''
   >>> np.arccos(units.Quantity(-1., ''))
   Quantity(3.14159265, 'rad')


.. _YggdrasilRapidJSON: https://github.com/cropsinsilico/yggdrasil-rapidjson
.. _Numpy ufuncs: https://numpy.org/doc/stable/reference/ufuncs.html
