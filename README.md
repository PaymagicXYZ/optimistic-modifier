# Optimistic Modifier

A module enabling opt-out "optimistic payouts" from a Gnosis safe

## Introduction

There has been much discussion about and effort dedicated to fixing the problem of the [lazy multisig signer.](https://twitter.com/SchorLukas/status/1559204622815924231) This module attempts to solve this problem by enabling safe opt-out transactions.
How is this achieved?

1. The module is an adaptation of the Zodiac Delay module which allows multisig signers to queue up transactions with a defined cooldown period. While the Delay module requires a Safe transaction that must meet the defined Safe threshold to cancel a queued transaction, the Optimistic Modifier gives any multisig signers the ability to cancel queued transactions.
2. After the cooldown period, the transaction can be executed by any Ethereum signer with the executeNextTxReimburse() function with a fee given to that signer in addition to reimbursement of the gas cost of calling this function. This incentivizes third parties to quickly and efficiency execute transactions on behalf of Safes.

The userflow of the Optimistic Modifier is as such:

1. A transaction is proposed with the execTransactionFromModule() function.
2. Any multisign signer can cancel the proposed transaction within the cooldown period.
3. If the proposed transaction has not been cancelled, anyone can call executeNextTxReimburse() and earn a fee plus gas reimbursement.

## Installation

```
git clone
```

To install with dependencies

```
forge build
```

## Local development

This project uses [Foundry](https://github.com/foundry-rs/foundry) as the development framework.

### Testing

```
forge test
```
