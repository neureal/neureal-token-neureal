pragma solidity ^0.4.24;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract NECPToken {
    function balanceOf(address) returns (uint256);
    //function totalSupply() returns (uint256);
    //function holders() returns (uint256);
    //function holder(uint256 i) returns (address, uint256);
}

contract NeurealToken {
    using SafeMath for uint256;

    /* ERC20 standard token */
    string public constant name = "Neureal";
    string public constant symbol = "NEUREAL";
    uint256 public constant decimals = 18;

    uint256 totalSupply_;
    mapping(address => uint256) balances;

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool) {
        // Non transferable
        //require(false);
        //assert(false);
        return false;
    }
    
    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    /* ERC20 Standard */


    /* Internal variables */
    uint256 constant MAXIMUM_SUPPLY = 1000000000 * 10**decimals;
    uint256 constant MAXIMUM_SALE = 888000000 * 10**decimals;
    //TODO Set this to the opening price per Neureal in ETH here based on https://www.coinbase.com/charts
    uint256 constant OPENING_PRICE_EACH = 1000000000 * 10**decimals;

    enum States {
        PreSaleUnfund,
        PreSaleFund,
        TGE1,
        TGE2,
        AfterSale,
        MUT,
        MVP1,
        MVP2,
        Release
    }
    States state = States.PreSaleUnfund;

    mapping(address => uint256) orders;

    /* Initializes contract */
    function NeurealToken() {

        //TODO *** Must call lockTransfers() as owner in NECPToken before creating this contract!!! ***

        // NECPToken _from = NECPToken(migrateFromContract);
        // uint256 _fromCount = _from.holders();
        // for (uint256 i = 0; i < _fromCount; i++) {
        //     var (_add, _bal) = _from.holder(i);
        //     if (_bal < 10000000000) continue; //dust
        //     uint256 _balConvert = _bal * 10000000000 * 400; //TODO add multiplier here
        //     if (_balConvert < _bal) continue; //uint256 overflow
        //     uint256 _newTotalSupply = totalSupply + _balConvert;
        //     if (_newTotalSupply > MAXIMUM_SUPPLY) continue; //max
        //     if (_newTotalSupply < totalSupply) continue; //uint256 overflow
        //     balanceOf[_add] = _balConvert;
        //     totalSupply = _newTotalSupply;
        // }
    }


    //TODO Set this to the Neureal Early Contributor Points (NECP) contract address
    address private constant migrateNECPFromContract = 0x91923993C4Dc3e089BBb1fc9d4A5A765A479B68f;
    mapping (address => bool) migratedNECP;

    /* Migrate balances from NECP holders */
    function migrateNECP(address _add) {
        require(_add != address(0));
        assert(totalSupply_ < MAXIMUM_SUPPLY); //??
        require(!migratedNECP[_add]);

        NECPToken _from = NECPToken(migrateNECPFromContract);

        uint256 _balConvert = _from.balanceOf(_add) * 10000000000 * 400; //TODO add multiplier here
        uint256 _newTotalSupply = totalSupply_ + _balConvert;
        if (_newTotalSupply > MAXIMUM_SUPPLY) { //max
            _balConvert = MAXIMUM_SUPPLY - totalSupply_;
            _newTotalSupply = MAXIMUM_SUPPLY;
        }

        migratedNECP[_add] = true;
        balances[_add] += _balConvert;
        totalSupply_ = _newTotalSupply;
        Transfer(msg.sender, _add, _balConvert); // Notify anyone listening that this transfer took place
    }




    /* purchase */
    /* This unnamed function is called whenever someone tries to send ether to it */
    function () payable {
        //already bought
        //below minimum
        //check blacklist (coinbase, etc)
        //add to order queue
    }

    /* send in vote of no confidence */
    function vote(boolean vote) {
        //
    }

    /* KYC/AML/accredited auth */
    function auth() {
        //check once within the bucket time
        //check KYC provider address
        //set variable yes/no authed for each
        //check if each address is in queue
        //pay ETH
    }
    
    /* fulfillment */
    function fulfillment() {
        //check once within the bucket time
        //sending the token to the buyers in the order queue
    }
    
    /* foundation allocation */
    function allocate(address _to, uint256 _value) onlyOwner {
        //create new token (under conditions) without costing ETH
    }

    /* send back locked ETH if needed */
    function refund(address _to) onlyOwner {
        //send back locked ETH
    }
    
    /* state transition */
    function transition() onlyOwner {
        //use timestamp "now" (block.timestamp), not "assert(past block x);" for timing
        //DONT use "selfdestruct(owner);" at end (on non test contract) because we need the contract open for automation access by new blockchain
    }
    
    

    // /* Send coins */
    // function transfer(address _to, uint256 _value) {
    //     if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
    //     if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
    //     if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
    //     balanceOf[msg.sender] -= _value;                     // Subtract from the sender
    //     balanceOf[_to] += _value;                            // Add the same to the recipient
    //     Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    // }

    // /* Allow another contract to spend some tokens in your behalf */
    // function approve(address _spender, uint256 _value) returns (bool success) {
    //     allowance[msg.sender][_spender] = _value;
    //     return true;
    // }

    // /* Approve and then communicate the approved contract in a single tx */
    // function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
    //     tokenRecipient spender = tokenRecipient(_spender);
    //     if (approve(_spender, _value)) {
    //         spender.receiveApproval(msg.sender, _value, this, _extraData);
    //         return true;
    //     }
    // }        

    // /* A contract attempts to get the coins */
    // function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    //     if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
    //     if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
    //     if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
    //     if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
    //     balanceOf[_from] -= _value;                           // Subtract from the sender
    //     balanceOf[_to] += _value;                             // Add the same to the recipient
    //     allowance[_from][msg.sender] -= _value;
    //     Transfer(_from, _to, _value);
    //     return true;
    // }


}
