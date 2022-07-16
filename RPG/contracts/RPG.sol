pragma solidity ^0.8.11;
contract RPG{
    // STRUCT FOR PLAYER CHARACTER
    struct Player{
        uint HP;
        string name;
        uint createdAt;
        uint exp;
        uint level;
    }
    // STRUCT FOR BOSS CHARACTER
    struct Boss{
        uint HP;
        string name;
         uint createdAt;
         uint exp;
        uint level;
    }
    //MAPPING ADDRESS TO PLAYER STRUCT
   mapping(address => Player)player;
   //MAPPING ADDRESS TO BOOLEAN TO CHECK IF ADDRESS OWNS A PLAYER
   mapping(address => bool)playerOwner;
   //MAPPING ADDRESS TO BOSS STRUCT     
   mapping(address => Boss)boss;
    //MAPPING ADDRESS TO BOOLEAN TO CHECK IF ADDRESS OWNS A BOSS
   mapping(address => bool)bossOwner;
   //MAPPING TO CHECK HOW MANY TIMES AN ADDRESS HAS TRAINED
   mapping(address => uint)Trained;
   //MAPPING TO CHECK IF AN ADDRESS HAS TRAINED
   mapping(address => bool)isTrained;
   //Mapping TO CHECK TIMES USER HAS BATTLED
   mapping(address => uint)Battle;
   // PLAYER COUNT
    uint private playerID = 0;
    //BOSS COUNT
    uint private bossID = 0;
    //BATTLE COUNT
    uint private battles = 0;
    //PRIZE MONEY
    uint private prize = 0.001 ether;
    //COOLDOWN FOR TRAINING
    uint private cooldown = 3 minutes;
    //TIME WHEN PLAYER TRAINED
    uint private traintime = 0;
    //TIMES AN ADDRESS HAS TRAINED
    uint private timestrained = 0;
    //ARRAY TO STORE OWNERS
    address[]private Owners;
    //ADDRESS OF OWNER OF CONTRACT 
   address private gameMaster;

   event PlayerCreated(address indexed by,string name,uint time);
   event BossCreated(address indexed by,string name,uint time);
   event PlayerDeleted(address indexed by,uint time);
   event Train(address indexed by,uint time);
   event BattleStart(address indexed by,string playername,string bossname, uint time);
   event BattleEnd(address indexed by, uint time);

   modifier onlyMaster(){
       require(msg.sender == gameMaster,"You are still a ROOKIE");
       _;
   }

   modifier isPlayerOwner(){
       require(playerOwner[msg.sender] == true,"You dont own a character");
       _;
   }
   modifier isBossOwner(){
       require(bossOwner[msg.sender] == true,"No boss Created");
       _;
   }
    modifier isNotBossOwner(){
       require(bossOwner[msg.sender] == false,"No boss Created");
       _;
   }
    modifier isNotPlayerOwner(){
       require(playerOwner[msg.sender] == false,"You already own a character");
       _;
   }


   constructor(){
       gameMaster = tx.origin;
   }

// CREATES A PLAYER LEAVE AS INTERNAL
    function CreatePlayer(string memory _name) isNotPlayerOwner internal returns(bool success){
        player[msg.sender].HP = 22;
        player[msg.sender].name = _name;
        player[msg.sender].createdAt = block.timestamp;
        player[msg.sender].exp = 0;
        player[msg.sender].level = 1;
        playerOwner[msg.sender] = true;
        Owners.push(msg.sender);
        playerID++;
        return true;
    }
// CREATES BOSS LEAVE AS INTERNAL
    function CreateBoss(string memory _name) isNotBossOwner internal returns(bool success){
        boss[msg.sender].HP = 25;
        boss[msg.sender].name = _name;
        boss[msg.sender].createdAt = block.timestamp;
        boss[msg.sender].exp = 0;
        boss[msg.sender].level = 1;
        bossOwner[msg.sender] = true;
        bossID++;
        return true;
    }
    
//CHECK PLAYER STATS LEAVE AS PUBLIC
    function CheckPlayerStats() isPlayerOwner public view returns(uint HP_,string memory name_, uint date_,uint exp_,uint level_){
        HP_ = player[msg.sender].HP;
        name_    = player[msg.sender].name; 
        date_ =  player[msg.sender].createdAt; 
        exp_ =   player[msg.sender].exp;
        level_ = player[msg.sender].level;

    }
    //CHECK BOSS STATS LEAVE AS PUBLIC
     function CheckBossStats() isBossOwner public view returns(uint HP_,string memory name_, uint date_,uint exp_,uint level_){
        HP_ = boss[msg.sender].HP;
        name_    = boss[msg.sender].name; 
        date_ =  boss[msg.sender].createdAt; 
         exp_ =   boss[msg.sender].exp;
        level_ = boss[msg.sender].level;
    }

//RETURNS TOTAL PLAYERS LEAVE AS PUBLIC
    function TotalPlayers()public view returns(uint){
       return playerID;
    }

//RETURN TOTOAL BOSS LEAVE AS PUBLIC
    function TotalBoss()public view returns(uint){
       return bossID;
    }

//RETURNS OWNER OF CONTRACT LEAVE AS PUBLIC
    function RevealGameMaster()public view returns(address){
        return gameMaster;
    }

    //REMOVES BOTH BOSS AND PLAYER CREATED BY USER USE WITH CARE LEAVE AS PUBLIC TOO

    function RemoveCharacters() isPlayerOwner isBossOwner public returns(bool success){
        playerOwner[msg.sender] = false;
        bossOwner[msg.sender] = false;
        Owners.pop();
        playerID--;
        bossID--;
        emit PlayerDeleted(msg.sender,block.timestamp);
        return true;
    }
    //SHOW TIME UNTIL NEXT TRAINING LEAVE AS PUBLIC
    function ShowCooldown()public view returns(uint){
        return cooldown + block.timestamp;
    }
  

    // THIS IS SUS BUT WHEN USER TRAINS PLAYER USER ALSO TRAINS BOSS *LOL* LEAVE AS PUBLIC
    function TrainPlayer() isPlayerOwner isBossOwner public returns(bool success){ 
        if(isTrained[msg.sender] == true){
            require(block.timestamp >= traintime + cooldown,"Wait 3 minutes to train again");
        }   
        player[msg.sender].exp += 85;
        if(player[msg.sender].exp >= 500){
            player[msg.sender].exp += 101;
            player[msg.sender].level++;
            player[msg.sender].HP++;
        }
        if(player[msg.sender].exp >= 1080){
            player[msg.sender].exp += 105;
            player[msg.sender].level = 3;
            player[msg.sender].HP++;
        }
        if(player[msg.sender].exp >= 2000){
            player[msg.sender].exp += 110;
            player[msg.sender].level = 4;
            player[msg.sender].HP++;
        }
        if(player[msg.sender].exp >= 5070){
            player[msg.sender].exp += 120;
            player[msg.sender].level = 5;
            player[msg.sender].HP++;
        }
        if(player[msg.sender].exp >= 10600){
            player[msg.sender].exp += 130;
            player[msg.sender].level = 6;
            player[msg.sender].HP++;
        }
        boss[msg.sender].exp += 85;
        if(boss[msg.sender].exp >= 500){
            boss[msg.sender].exp += 101;
            boss[msg.sender].level++;
            boss[msg.sender].HP++;
        }
        if(boss[msg.sender].exp >= 1080){
            boss[msg.sender].exp += 105;
            boss[msg.sender].level = 3;
            boss[msg.sender].HP++;
        }
        if(boss[msg.sender].exp >= 2000){
            boss[msg.sender].exp += 110;
            boss[msg.sender].level = 4;
            boss[msg.sender].HP++;
        }
        if(boss[msg.sender].exp >= 5070){
            boss[msg.sender].exp += 120;
            boss[msg.sender].level = 5;
            boss[msg.sender].HP++;
        }
        if(boss[msg.sender].exp >= 10600){
            boss[msg.sender].exp += 130;
            boss[msg.sender].level = 6;
            boss[msg.sender].HP++;
        }
        timestrained++;
        Trained[msg.sender] = timestrained;
        isTrained[msg.sender] = true;
        traintime = block.timestamp;
        emit Train(msg.sender,block.timestamp);
        return true;
    }
 // REVEALS PRIZE AFTER EACH BATTLE LEAVE AS PUBLIC
    function ShowPrize()public view returns(uint){
        return prize;
    }
   //PUBLIC FUNCTION TO SET PRIZE AMOUNT
    function _SetPrize(uint value)public{
        SetPrize(value);
    }
 //SETS PRIZE MONEY IF OWNER WANTS TO CHANGE IT SET AS INTERNAL
    function SetPrize(uint _prize)internal onlyMaster returns(bool success){
        require(_prize >= 0.01 ether,"Prize is too low");
        prize = _prize;
        return true;
    }
    //FUNCTION TO CHECK HOW MANY TIME PLAYER HAS TRAINED LEAVE AS PUBLIC
    function TimesTrained()public view returns(uint){
        return Trained[msg.sender];
    }
    //FUNCTION TO CHECK TIMES BATTLED
    function TimesBattled()public view returns(uint){
        return Battle[msg.sender];
    }

  //FUNCTION TO START BATTLE ALSO CREATES PLAYER AND BOSS AS A RESULT LEAVE AS PUBLIC 
    function StartBattle(string memory playername,string memory bossname) public returns(bool success){
        emit BattleStart(msg.sender, playername, bossname,block.timestamp);
        ShowPrize();
        CreatePlayer(playername);
        emit PlayerCreated(msg.sender, playername,block.timestamp);
        CreateBoss(bossname);
        emit BossCreated(msg.sender, bossname,block.timestamp);
        return true;
    }
//FUNCTION TO END BATTLE MUST OWN PLAYER AND BOSS TO CALL FUNCTION
    function EndBattle() public isPlayerOwner isBossOwner returns(bool success){
        emit BattleEnd(msg.sender,block.timestamp);
       // require(address(this).balance >= prize,"Balance not sufficient");
        //payable(msg.sender).transfer(prize);
        battles++;
        Battle[msg.sender] = battles;
        return true;
    }
    
   

   
}