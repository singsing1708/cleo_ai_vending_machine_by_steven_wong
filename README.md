# VendingMachine

## 1. Project background

This project implements a vending machine with following functional requirements.

### Functional Requirement

- Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product
- It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted
- The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2
- There should be a way of reloading either products or change at a later point
- The machine should keep track of the products and change that it contains


### Features implemented

Vending Machine Features

- User: Insert Coins
- User: Return Coins
- User: Purchase Product
- User: Show Current Credit

- Admin: Update Product Quantity
- Admin: Update Wallet Quantity
- Admin: Update Product Quantity
- Admin: Show Wallet
- Admin: Show Product


## 2. Folder Structure

logic and coding are inside `lib/`
- `lib/vending_machine.rb` is main class entry point

vending machine init data in `lib/data`

test cases (using RSpec) are inside `spec/` and testing data in `spec/fixtures`


## 3. Running the Vending Machine

### install dependencies

```
$ rvm install 2.7.2
$ rvm use 2.7.2
$ gem install bundler
$ bin/setup
```

### running test cases

```
$ rspec
```

## work log

- draft requirement_pseudo_code for the overall user flow
- start new gem and prepare folder structure
- (0.5 hour used in total)
- started to build with UI however discovered time is limited and change to implement function with test cases
- (1 hour used in total)
- created the vending machine, wallet, product classes with data
- (2.0 hour used in total)
- implemented with customer_wallet and machine_wallet
- discovered the return_coins issue, changed to vending_machine.credit with only 1 wallet (machine_wallet) and implemented the whole flow
- implement the admin update coin and quantity
- (4.0 hour used in total)
- implement the test classes
- (5.25 hour used in total)
- update the README
- (5.5 hour used in total)
