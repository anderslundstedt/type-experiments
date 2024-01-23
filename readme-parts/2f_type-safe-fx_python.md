One catch is that classes and functions may not be parameterized by values but
only by types. My “hacky” solution to this:

- Each currency representation is a class. In
  [python-3.12/finance/currencies.py](python-3.12/finance/currencies.py) each
  such currency class is defined.

- The type `t_ccy` is the
  [union type](https://docs.python.org/3/library/typing.html#typing.Union)
  of the currency classes.

- In `c_money[tv_ccy: t_ccy]`, `tv_ccy` is a
  [type variable](https://docs.python.org/3/library/typing.html#typing.TypeVar)
  constrained to `t_ccy`: in a type annotation `c_money[T]`, `T` must be one of
  of the currency classes.

- The hacky part is `ccy : F[type[tv_ccy]]`. This has the consequence that when
  creating and type annotating a `c_money[–]` object, we must use the same type
  both in the type annotation and as argument to the constructor (for our code
  to pass pyright's type checking).

  - This passes type checking:

    ```py
    some_USD : c_money[USD] = c_money(USD, 10)
    ```

  - This does not:

    ```py
    some_USD : c_money[USD] = c_money(EUR, 10)
    ```

- We use the same solution when type annotating our currency conversion
  function:

  ```py
  def fx[tv_fr_ccy: t_ccy, tv_to_ccy: t_ccy](
      money: c_money[tv_fr_ccy], to_ccy: type[tv_to_ccy]
  ) -> c_money[tv_to_ccy]:
      …
  ```

  See
  [python-3.12/finance/fx.py](python-3.12/finance/fx.py).

  - This passes type checking:

    ```py
    some_USD : c_money[USD] = c_money(USD, 10)
    some_EUR : c_money[EUR] = fx(some_USD, EUR)
    ```

  - This does not:

    ```py
    some_USD : c_money[USD] = c_money(USD, 10)
    some_EUR : c_money[EUR] = fx(some_USD, SEK)
    ```
