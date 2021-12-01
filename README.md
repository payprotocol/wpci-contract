# Wrapped MLK token contract

ERC20 based token for wrapping MLK.

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
truffle(develop)> wt.wrap('0x10Cab1d6d00F0f505A5010255936857C83DcfE54', '12300000000', '0x77742e756e777261702827307835303433343933303331333933333335333633')
truffle(develop)> wt.wrapped('0x903fe80DD36F6527753c48bb3AC48DE8E21257A0')
truffle(develop)> (await wt.balanceOf('0xc4b50dd1042c8e7c5837ae084beafe9c28213233')).toString()
truffle(develop)> wt.unwrap('PCI01EF50758D506AD9570B1C567123B0390D9F5AEE651770018A', '1000')
```

## GO ABI binding

- See [GO Contract Binding](https://geth.ethereum.org/docs/dapp/native-bindings)