const { forceImport, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const WPCI = artifacts.require('WPCI');

module.exports = async function (deployer, network, accounts) {
  // -----------이전 버전의 sol 컴파일 한 후 실행----------------------
  // const proxyAddress = '0xa3924788e7c308a33d0a2DcCcCAf7BDfadd9d5Ed';
  // console.log("[STEP] forceImport 시작:", proxyAddress);
  // await forceImport(proxyAddress, WPCI, { kind: 'uups' });
  // console.log("[STEP] forceImport 완료 / proxy 등록:", proxyAddress);


  // -----------새로운버전의 sol 컴파일 한 후 실행----------------------
  const proxyAddress = '0xa3924788e7c308a33d0a2DcCcCAf7BDfadd9d5Ed';
  console.log("[STEP] upgradeProxy 시작:", proxyAddress);
  const instance = await upgradeProxy(proxyAddress, WPCI, { kind: 'uups' });
  console.log("[STEP] upgradeProxy 완료, proxy:", instance.address);
};


// 종종 실패함.