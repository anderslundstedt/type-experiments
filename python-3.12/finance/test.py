# IMPORTS

from typing import Final as F

from finance.currencies import EUR, USD, SEK
from finance.fx import fx
from finance.money import c_money



# MAIN

if __name__ == '__main__':
    # no type errors
    some_EUR : F[c_money[EUR]] = c_money(EUR, 100.0)
    some_USD : F[c_money[USD]] = c_money(USD, 100.0)
    some_SEK : F[c_money[SEK]] = c_money(SEK, 100.0)

    # type errors
    not_some_EUR : F[c_money[EUR]] = c_money(USD, 100.0) # pyright: ignore [reportGeneralTypeIssues]
    not_some_USD : F[c_money[USD]] = c_money(SEK, 100.0) # pyright: ignore [reportGeneralTypeIssues]
    not_some_SEK : F[c_money[SEK]] = c_money(EUR, 100.0) # pyright: ignore [reportGeneralTypeIssues]

    # no type errors
    some_EUR_in_EUR : F[c_money[EUR]] = fx(some_EUR, EUR)
    some_USD_in_EUR : F[c_money[EUR]] = fx(some_USD, EUR)
    some_SEK_in_EUR : F[c_money[EUR]] = fx(some_SEK, EUR)
    some_EUR_in_USD : F[c_money[USD]] = fx(some_EUR, USD)
    some_USD_in_USD : F[c_money[USD]] = fx(some_USD, USD)
    some_SEK_in_USD : F[c_money[USD]] = fx(some_SEK, USD)
    some_EUR_in_SEK : F[c_money[SEK]] = fx(some_EUR, SEK)
    some_USD_in_SEK : F[c_money[SEK]] = fx(some_USD, SEK)
    some_SEK_in_SEK : F[c_money[SEK]] = fx(some_SEK, SEK)

    # type errors
    not_some_EUR_in_EUR : F[c_money[EUR]] = fx(some_EUR, USD) # pyright: ignore [reportGeneralTypeIssues]
    not_some_USD_in_EUR : F[c_money[EUR]] = fx(some_USD, USD) # pyright: ignore [reportGeneralTypeIssues]
    not_some_SEK_in_EUR : F[c_money[EUR]] = fx(some_SEK, USD) # pyright: ignore [reportGeneralTypeIssues]
    not_some_EUR_in_USD : F[c_money[USD]] = fx(some_EUR, SEK) # pyright: ignore [reportGeneralTypeIssues]
    not_some_USD_in_USD : F[c_money[USD]] = fx(some_USD, SEK) # pyright: ignore [reportGeneralTypeIssues]
    not_some_SEK_in_USD : F[c_money[USD]] = fx(some_SEK, SEK) # pyright: ignore [reportGeneralTypeIssues]
    not_some_EUR_in_SEK : F[c_money[SEK]] = fx(some_EUR, EUR) # pyright: ignore [reportGeneralTypeIssues]
    not_some_USD_in_SEK : F[c_money[SEK]] = fx(some_USD, EUR) # pyright: ignore [reportGeneralTypeIssues]
    not_some_SEK_in_SEK : F[c_money[SEK]] = fx(some_SEK, EUR) # pyright: ignore [reportGeneralTypeIssues]

    print(some_EUR)
    print(some_EUR_in_SEK)
    print(some_USD)
    print(some_USD_in_SEK)
