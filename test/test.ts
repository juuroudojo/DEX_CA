import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract, ContractFactory, BigNumber } from "ethers";
import { parseEther } from "ethers/lib/utils";
import { readFile } from "fs/promises";
var Web3 = require('web3');


describe("Bridge", () => {
  let DEX: ContractFactory;
  let dex: Contract;
  let DAI: Contract;
  let WETH: Contract;
  let Ippo: SignerWithAddress;
  let Takamura: SignerWithAddress;
  let Miyata: SignerWithAddress;
  let Aoki: SignerWithAddress;

 

  before(async () => {
    [Ippo, Takamura, Miyata, Aoki] = await ethers.getSigners();
  });

  beforeEach(async () => {
    DEX = await ethers.getContractFactory("DEX1");
    dex = await DEX.deploy();
    await dex.deployed();
  })

  describe("SWAP", async () => {
    it("Should swap", async() => {
      const weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
      const daiAddr = "0x6B175474E89094C44Da98b954EedeAC495271d0F";


      await Ippo.sendTransaction({
        to: dex.address,
        value: ethers.utils.parseEther("1")
      })

      const addr = "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7";

      let wethh = await readFile("../DEX_CA/abi/wethabi.json");
      const wet = JSON.parse(wethh.toString());

      WETH = await ethers.getContractAt(wet, weth)
      DAI = await ethers.getContractAt("IERC20", daiAddr);
      let balance = await DAI.balanceOf(addr);
      console.log(balance);

      await WETH.deposit({value:ethers.utils.parseEther("2")});

      console.log(await DAI.balanceOf(Ippo.address));

      await dex.swapWETHToDai({value:ethers.utils.parseEther("1")});

      console.log(await DAI.balanceOf(Ippo.address));
    })
  })
})