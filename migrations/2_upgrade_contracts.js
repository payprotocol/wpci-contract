const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const WPCI = artifacts.require('WPCI');


module.exports = async function (deployer, network) {
  var proxyAddress = '';
  switch (network) {
    case 'sepolia':
      proxyAddress = '0xa1f5612B00A4Ce54d512C4B28801B3fC5A78D4A6';
      break;
    case 'goerli':
      proxyAddress = '0x045e20F418649C9e6d8d1fEAabDa562Bf37F7c80';
      break;
    case 'live':
      proxyAddress = '0x3C2A309d9005433c1BC2C92EF1bE06489e5bf258';
      break;
    default :
      return console.error('Error: There is no proxy address.');
  }
  const instance = await upgradeProxy(proxyAddress, WPCI);
  console.log('Upgraded', instance.address);
};
