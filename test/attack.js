const {expect} = require('chai')
const { BigNumber } = require('ethers')
const { ethers, waffle } = require('hardhat')
const { isCallTrace } = require('hardhat/internal/hardhat-network/stack-traces/message-trace')

describe("Attack", function (){
    it("After being declared as a winner, Attack.sol should not let anyone bet after that", async() => {

        const goodContract = await ethers.getContractFactory("Good")
        const _goodContract = await goodContract.deploy()
        await _goodContract.deployed()

        console.log("Address of the good contract",_goodContract.address)

        const attackContract = await ethers.getContractFactory("Attack")
        const _attackContract = await attackContract.deploy(_goodContract.address)
        await _attackContract.deployed()

        console.log("Address of the attack contract",_attackContract.address);

        const [_, add1, add2] = await ethers.getSigners()

        let tx = await _goodContract.connect(add1).setCurrentAuctionPrice({
            value : ethers.utils.parseEther("1"),
        })
        await tx.wait()

        tx = await _attackContract.attack({
            value: ethers.utils.parseEther("3.0"),
        })
        await tx.wait();

        tx = await _goodContract.connect(add2).setCurrentAuctionPrice({
            value: ethers.utils.parseEther("4"),
        })
        await tx.wait();

        expect(await _goodContract.currentWinner()).to.equal(_attackContract.address);

    })
})