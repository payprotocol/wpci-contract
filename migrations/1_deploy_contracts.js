const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WPCI = artifacts.require('WPCI');

module.exports = async function (deployer) {
  let instance;
  let network = 'goerli';
  if (network !== 'live') {
    instance = await deployProxy(WPCI, { kind: 'uups' });
  } else {
    instance = await deployProxy(WPCI, ['0xdD912294537Dee0Af1713345Ab4109529e34FD57'], { kind: 'uups' });
  }
  console.log('Deployed', instance.address);
};
