from typing import ClassVar as CV, Self as Self, TypeAlias as TA

# The currencies need to be types. In match statements──see the finance.fx
# module──we create instances of each currency class. Thus it is a good idea to
# make currencies singleton classes.

def _mk_ccy_singleton_class(name: str):
    class c(str):
        instance : CV[Self | None] = None
        def __new__(cls) -> Self:
            if cls.instance is None:
                cls.instance = super().__new__(cls, name)
            return cls.instance
    return c

class EUR(_mk_ccy_singleton_class('EUR')): pass
class USD(_mk_ccy_singleton_class('USD')): pass
class SEK(_mk_ccy_singleton_class('SEK')): pass

t_ccy : TA = EUR | USD | SEK
