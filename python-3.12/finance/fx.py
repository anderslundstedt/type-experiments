# IMPORTS

from dataclasses import dataclass
from typing import Final as F

from finance.currencies import EUR, USD, SEK, t_ccy
from finance.money import c_money



# PUBLIC

@dataclass(frozen=True, kw_only=True)
class c_fx_rate[tv_fr_ccy: t_ccy, tv_to_ccy: t_ccy]:
    fr_ccy : F[type[tv_fr_ccy]]
    to_ccy : F[type[tv_to_ccy]]
    quote  : F[float]


def get_fx_rate[tv_fr_ccy: t_ccy, tv_to_ccy: t_ccy](
    *, fr_ccy: type[tv_fr_ccy], to_ccy: type[tv_to_ccy]
) -> c_fx_rate[tv_fr_ccy, tv_to_ccy]:
    return c_fx_rate[tv_fr_ccy, tv_to_ccy](
        fr_ccy=fr_ccy,
        to_ccy=to_ccy,
        quote=_get_quote(fr_ccy=fr_ccy, to_ccy=to_ccy)
    )

def fx[tv_fr_ccy: t_ccy, tv_to_ccy: t_ccy](
    money: c_money[tv_fr_ccy], to_ccy: type[tv_to_ccy]
) -> c_money[tv_to_ccy]:
    return c_money[tv_to_ccy](
        to_ccy, money.amount*_get_quote(fr_ccy=money.ccy, to_ccy=to_ccy)
    )



# PRIVATE

def _get_quote(*, fr_ccy: type[t_ccy], to_ccy: type[t_ccy]) -> float:
    # quotes as of 2024-01-23
    def invert() -> float:
        return 1/_get_quote(fr_ccy=to_ccy, to_ccy=fr_ccy)
    match fr_ccy():
        case EUR():
            match to_ccy():
                case EUR(): return 1
                case USD(): return 1.08
                case SEK(): return 11.37
        case USD():
            match to_ccy():
                case EUR(): return invert()
                case USD(): return 1
                case SEK(): return 10.4
        case SEK():
            match to_ccy():
                case EUR(): return invert()
                case USD(): return invert()
                case SEK(): return 1
