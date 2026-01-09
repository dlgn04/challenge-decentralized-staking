import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat/";
import { DiceGame } from "../typechain-types";

const deployRiggedRoll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Lấy địa chỉ DiceGame đã deploy
  const diceGame: DiceGame = await ethers.getContract("DiceGame");
  const diceGameAddress = await diceGame.getAddress();

  // DEPLOY RiggedRoll (BẮT BUỘC)
  await deploy("RiggedRoll", {
    from: deployer,
    log: true,
    args: [diceGameAddress],
    autoMine: true,
  });
};

export default deployRiggedRoll;

// TAG để deploy riêng RiggedRoll
deployRiggedRoll.tags = ["RiggedRoll"];
