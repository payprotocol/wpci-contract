// migrations/3_deploy_wpci_impl_arbitrum.js
const WPCI = artifacts.require("WPCI");

module.exports = async function (deployer, network, accounts) {


  await deployer.deploy(WPCI);
  const impl = await WPCI.deployed();
  console.log(`[Arbitrum][${network}] New WPCI implementation:`, impl.address);
};