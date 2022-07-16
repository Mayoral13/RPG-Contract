const Game = artifacts.require("RPG");

module.exports = function (deployer) {
  deployer.deploy(Game);
};
