pragma solidity ^3.0.2;

contract P2P_Lottery {
    event getStarted(uint bet);  //fix the bet amount
    event Staked(address indexed player);  // player stakes the bet amount
    event Committed(uint256 your_bit);
    event Reveal();
    event verify();
    event result();

    enum State {
        waiting_for_Player, staking, staked, Committed, verified, rewarded
    }

    address public onwer;
    address[2] public players;
    State public state;
    uint256 public bet;
    uint256 public pool;


    modifier byPlayer() {
        require(msg.sender == player);
    }

    modifier inState(State expected) {
        require(state == expected)
    }

    constructor (uint256 _bet) public {
        require(_bet > 0);

        owner = msg.sender;
        state = State.waiting_for_Player;
        bet = _bet;

        emit getStarted(bet);
        
        //Protect against overflow
        asserts(getReward() > _bet); //Reward should be greater than bet amount
    }


    function stake(address _player, uint chosen_bit) public payable inState(State.staking) {
        assert(msg.value == bet);

        players[] = msg.sender;

        // Increase pot for each participant.
        pool += msg,value;

        emit Staked(_player);

        uint256 commitment[2] = commit(chosen_bit);

    }

    //function to generate a random number
    function rand() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(now,block.difficulty,msg.sender)));
    }

    //player commits the chosen bit
    function commit(uint _bit) public view returns(uint256) {

        //generate a random number to append with chosen bit
        uint memory nonce = rand();

        //appends the random number to the chosen bit, produces and returns commitment
        uint256 memory commitment = uint256(keccak256(abi.encodePacked(2*nonce + _bit)));

        return commitment;

        state_update(State.Committed);

    }

    // player reveals the chosen bit and the nonce; the contract verifies it
    function verification(address _player, uint _chosen_bit, uint _nonce) view {
        require(state == State.Committed);

        uint bits = _chosen_bit;
        uint result_;
        if(commitment[msg.sender] == uint(keccak256(abi.encodePacked(now,block.difficulty,msg.sender)))) {
            state_update(State.verified);

            result(players,bits);
        }

            



    }

    //result declaration
    function result(address _player, uint _bit) view returns(uint _result) {

    }


    //change state
    function state_update(State _state) private {
        state = _state;

    } 

}
