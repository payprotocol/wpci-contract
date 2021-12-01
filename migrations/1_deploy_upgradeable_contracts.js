const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WPCI = artifacts.require('WPCI');

module.exports = async function (deployer) {
  const instance = await deployProxy(WPCI, { kind: 'uups' });
  console.log('Deployed', instance.address);
};
// wt.wrap('0x512AE052E0682781f7714E9f742FAD58E233A5F2', '12300000000', '0x2dda34f2183b84cebfa93b2c47e0db3c889b1543f26c5f317ce3f6ab46e66a1e')
// wt.wrapped('0xcBeAb166D5a04df3C53513F11B12D49092Ad90d0')
// (await wt.balanceOf('0x512AE052E0682781f7714E9f742FAD58E233A5F2')).toString()