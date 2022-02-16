const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  var proxyAddress = '';
  switch (network) {
    case 'kovan':
      proxyAddress = '0xa4edf84181141400E8766DCD1113a21CFf0AeD78';
      break;
    case 'live':
      proxyAddress = '0x3C2A309d9005433c1BC2C92EF1bE06489e5bf258';
      break;
    default :
      return console.error('Error: There is no proxy address.');
  }
  const instance = await upgradeProxy(proxyAddress, WMLK);
  console.log('Upgraded', instance.address);
};
