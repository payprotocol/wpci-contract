const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WPCI = artifacts.require('WPCI');

module.exports = async function (deployer) {
  const instance = await deployProxy(WPCI, { kind: 'uups' });
  console.log('Deployed', instance.address);
};
