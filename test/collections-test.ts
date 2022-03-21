import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract, ContractTransaction, Signer, BigNumber } from 'ethers';

import type { Collections, DocGovernor, GovernanceERC20Token } from '../typechain';

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});

describe("Collections", function () {
  let provider: typeof ethers.provider
  let allSigners: Signer[]
  let signer: Signer
  let account: string
  let allAccounts: string[]
})