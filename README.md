# typing-experiments

Some experiments with static type checking—so far mainly using
[Coq](https://coq.inria.fr/)
and the Python type checker
[pyright](https://github.com/microsoft/pyright).
## Type-safe currency conversions

Abbreviations:

- ‘ccy’ for ‘currency’
- ‘fx’  for ‘foreign exchange’
- ‘fr’  for ‘from’

When I last programmed professionally, many years ago now, one thing that
bothered me more than once was that it seems like one cannot construct a
type-safe function for currency conversion—if one does not have some amount of
[dependent types](https://en.wikipedia.org/wiki/Dependent_type)
in one's type system. In some more detail: some amount of dependent types seems
necessary for a sufficiently type-safe function converting a monetary amount in
one currency to a monetary amount in another currency. Hopefully the following
subsections explains what I mean with ‘sufficiently type-safe’ in the preceding.

### “Naive” solution (without dependent types)

Consider the following. Assume we have:

- Types `t_ccy` (the type of currencies) and `t_amount` (some amount
  type—fixed-point numbers, say).
- At least two `t_ccy` objects—`USD` and `EUR` say.
- A data type `t_money`:  
  
  ```
  data t_money:
    ccy    : t_ccy
    amount : t_amount
  ```
- A `t_money` object `some_money_USD`, its name correctly reflecting  
  
  ```
  some_money_USD.ccy = USD
  ```
- A function `fx` for currency conversion of `t_money` objects:  
  
  ```
  fx : t_money → t_ccy → t_money
  ```
  The first argument to `fx` represents money to sell; the second argument
  represents the currency of the purchasing money.

Now say we want the equivalent of our `some_money_USD` in EUR:
```
some_money_EUR : t_money ≔ fx(some_money_USD, EUR)
```

So far so good. The problem is that the following also type checks, where we
have a typo with `USD` instead of `EUR` as last argument to `fx`.
```
some_money_EUR : t_money ≔ fx(some_money_USD, USD)
```

One solution, not requiring dependent types, for making that typo harder would
be to require named arguments (supported by Python, for example). The above
mistake would then be easier to catch:
```
some_money_EUR : t_money ≔ fx(money_to_sell=some_money_USD, ccy_to=USD)
```

Notice however that it is only due to us including the currency name in each
object's name that the typo is easier to catch with named arguments—consider:
```
some_different_money : t_money ≔ fx(money_to_sell=some_money, ccy_to=USD)
```

While choosing good names is important, it would be good if the type system
catched such mistakes.

### A “sufficiently type-safe” solution (using dependent types)

Recall the data type `t_money` from the preceding section:
```
data t_money:
  ccy    : t_ccy
  amount : t_amount
```

We “promote” the `ccy` field to a parameter of the
`t_money` type:
```
data t_money[t_ccy]:
  amount : t_amount
```
Roughly, this means that each `t_ccy` object has its own `t_money` type:
```
some_USD_money : t_money[USD] ≔ …
some_EUR_money : t_money[EUR] ≔ …
```

The type of our `fx` function now becomes:
```
fx : Π(ccy_fr: t_ccy, ccy_to: t_ccy)(t_money[ccy_fr] → t_money[ccy_to])
```
This is a dependently typed function: the types `t_money[ccy_fr]` and
`t_money[ccy_to]` depend on the arguments `ccy_fr` and `ccy_to`, respectively.
This is why `ccy_fr` and `ccy_to` are within `Π( … )`—a common (I think) syntax
for
[dependent product types](https://en.wikipedia.org/wiki/Dependent_type#Π_type).

Using our dependently typed `fx` function to turn some USD into some EUR of
equal value:
```
some_EUR_money : t_money[EUR] ≔ fx(USD, EUR, some_USD_money)
```

As long as we type our money objects correctly, the typos in the preceding
section are caught by type checking. For example, the following, where we mix up
the order of the arguments to `fx`, does not type check:
```
money_1 : t_money[USD] ≔ …
money_2 : t_money[EUR] ≔ fx(EUR, USD, money_1)
```
#### Coq 8.16 implementation

See the quite generously commented
[coq-8.16/fx.v](coq-8.16/fx.v).
#### Python 3.12 implementation

TODO
