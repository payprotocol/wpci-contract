# Wrapped PCI (WPCI) token contract

ERC20 based token for wrapping PCI.

## Upgradeable contract

- UUPS proxy pattern ([EIP1822](https://eips.ethereum.org/EIPS/eip-1822))
- [OpenZeppelin Truffle Upgrades API](https://docs.openzeppelin.com/upgrades-plugins/1.x/api-truffle-upgrades)

## Installation

```sh
% npm install
```

## Compile

```sh
% truffle compile
```

## Run 

Run local dev node and console
```sh
% truffle develop
```

Migrate (complie & deploy)
```
truffle(develop)> migrate
```

Example
```
truffle(develop)> wt = await WPCI.deployed()
truffle(develop)> wt.address
truffle(develop)> wt.wrap(accounts[0], '12300000000', '0x77742e756e777261702827307835303433343933303331333933333335333633')
truffle(develop)> wt.wrapped('0x77742e756e777261702827307835303433343933303331333933333335333633')
truffle(develop)> (await wt.balanceOf(accounts[0])).toString()
truffle(develop)> wt.unwrap('PCI01EF50758D506AD9570B1C567123B0390D9F5AEE651770018A', '1000')
```

## Migration
```sh
% truffle migrate --network kovan
// specific files
% truffle migrate -f 2 --to 2 --network kovan
```

## Source Code Flatten (for Verification)

1. Go [Remix Ethereum IDE](https://remix.ethereum.org/)
2. Create a contract source file in the contracts folder
3. Add the module version to import statements
```solidity
import "@openzeppelin/contracts-upgradeable@4.5.1/...
```
4. Choose the compiler version and compile
5. Add the 'FLATTENER' plugin and use it

## GO ABI binding

- See [GO Contract Binding](https://geth.ethereum.org/docs/dapp/native-bindings)