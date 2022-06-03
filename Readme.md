## Problem statement

This example is distilled from real-life csv data exports from the Revolut bank.

Data in `csv`
 - has a start date - date of action by the user
 - has a completion date - moment when the transaction was treated by the bank
 - data is sorted with respect to that "completion date"
 - data contains balance assertions *at the moment of completion date*

Printing (or importing) this csv data with the corresponding `rules` file yields the following journal file (`hledger-1.25`)

```ledger
2022-01-01 First topup
    Assets            100EUR = 100EUR  ; date: 2022-01-01
    Unsorted         -100EUR

2022-01-01 First expense
    Assets            -10EUR = 1090EUR  ; date: 2022-01-02
    Unsorted           10EUR

2022-01-02 Second topup
    Assets           1000EUR = 1100EUR  ; date: 2022-01-02
    Unsorted        -1000EUR
```

(`hledger print -f data.csv`)

Clearly, balance assertions are not satisfied - because their order changed with respect their timeline. As far as I undestand, sorting with respect to transaction date is hardcoded in hledger.

## Possible solutions
- `hlender import`/`hledger print` csv lines one by one via a custom script; error-prone, but doable
- sort entries manually; tedious
- drop balance assertions; I am reluctant to do so
- use completion date as transaction date; looks like going against the source of truth
- some import option that I missed

### Note on manual ordering

If we order entries as they are in the CSV file, assertions work!

```ledger

; fixed.journal

2022-01-01 First topup
    Assets            100EUR = 100EUR  ; date: 2022-01-01
    Unsorted         -100EUR

2022-01-02 Second topup
    Assets           1000EUR = 1100EUR  ; date: 2022-01-02
    Unsorted        -1000EUR

2022-01-01 First expense
    Assets            -10EUR = 1090EUR  ; date: 2022-01-02
    Unsorted           10EUR
```

