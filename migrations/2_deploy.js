// migrations/2_deploy.js
const LinksHandicap = artifacts.require('LinksHandicap');

module.exports = async function (deployer) {
  await deployer.deploy(LinksHandicap);
};