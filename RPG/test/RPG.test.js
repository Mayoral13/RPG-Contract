const Game = artifacts.require("RPG");
let catchRevert = require("../execption").catchRevert;

contract("rpg",(accounts) => {
    let master = accounts[0];
    let user = accounts[1];
    let user1 = accounts[2];
    let user2 = accounts[3];

    it("Should deploy successfully",async()=>{
        const alpha = await Game.deployed();
        const address = await alpha.address;
        console.log("The address is :",address.toString());
        assert(address != "");
    });

    it("Game master should be deployer of the contract",async()=>{
        const alpha = await Game.deployed();
        const expected = await alpha.RevealGameMaster();
        console.log("The expected address is: ",expected.toString());
        assert.equal(master,expected,"ERROR");
    });


    it("Should revert if user checks player stats without creating one",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha.CheckPlayerStats({from:user1}));
    });


    it("Should revert if user checks player stats without creating boss",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha.CheckBossStats({from:user1}));
    });


    it("Should revert if user tries to remove characters without owning",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha.RemoveCharacters({from:user1}));
    });

    it("Should revert if user tries to train player without owning",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha.TrainPlayer({from:user1}));
    });


    it("Can return prize value",async()=>{
        const alpha = await Game.deployed();
        const expected = alpha.ShowPrize();
        console.log("The Prize money is :",expected.toString());
        assert(expected != 0);
    });

    it("Should revert if user tries to end battle without owning player",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha.EndBattle({from:user1}));
    });


    it("Should be able to Start Battles and create characters",async()=>{
        const alpha = await Game.deployed();
        const start = alpha.StartBattle("John","Cena");
        const value = await alpha.TotalPlayers();
        console.log("Number of players are :",value.toString());
        assert(value != "");
    });


    it("Should revert if non master tries to change prize",async()=>{
        const alpha = await Game.deployed();
        await catchRevert(alpha._SetPrize(100,{from:user1}));
    });


    
    it("Can train player if owns a character",async()=>{
        const alpha = await Game.deployed();
        const train = await alpha.TrainPlayer();
        const expected = 1;
        const value = await alpha.TimesTrained();
        assert.equal(value,expected);

    });

    it("Can End Battles",async()=>{
        const alpha = await Game.deployed();
        const start = alpha.StartBattle("Johnny","Cenaix",{from:user});
        const expected = 1;
        const beta = await alpha.EndBattle({from:user});
        const value = await alpha.TimesBattled({from:user});
        console.log("Times Battles are :",value.toString());
        assert.equal(value,expected);
    }); 
});