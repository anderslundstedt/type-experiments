from dataclasses import dataclass
from typing import Final as F

from finance.currencies import t_ccy



@dataclass(frozen=True)
class c_money[tv_ccy: t_ccy]:
    ccy    : F[type[tv_ccy]]
    amount : F[float]
