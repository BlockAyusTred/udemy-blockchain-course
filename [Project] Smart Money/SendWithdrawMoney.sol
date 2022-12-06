// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

contract SendWithdrawMoney {

    address payable public owner;
    uint public balance;
    mapping(address => uint) public allowance;
    mapping(address => bool) public isAlloweded;
    mapping(address => bool) public guardians;

    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationFromGuardiansForReset = 3;
    mapping(address => mapping(address=>bool)) public nextOwnerGuardianVotedBool;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balance += msg.value;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function proposingNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], " you are not guardian of this wallet, aborting");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false , "you already voted, aborting");
        if(_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount =0;
        }

        guardiansResetCount++;
        nextOwnerGuardianVotedBool[_newOwner][msg.sender] = true;

        if(guardiansResetCount >= confirmationFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setGuardian(address _guardian, bool _isGuardian) public onlyOwner {
        guardians[_guardian] = _isGuardian;
    }

    function giveAllowance(address _to, uint amount) public onlyOwner sufficientBalance(amount) {
        allowance[_to] += amount;
        if(amount >0) {
            isAlloweded[_to] = true;
        }else {
            isAlloweded[_to] = false;
        }
    }

    function withdraw(uint amount) public onlyOwner sufficientBalance(amount) {
        owner.transfer(amount);
    }

    function withdrawAll() public onlyOwner {
        owner.transfer(getBalance());
    }

    function transfer(address payable _to, uint _amount) public onlyOwner sufficientBalance(_amount) {
        _to.transfer(_amount);
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        if(msg.sender != owner) {
            require(isAlloweded[msg.sender], "you are not allowded to send from this smart contract, Aborting");
            require(allowance[msg.sender] >= _amount, "you are trying to send more than you are allowed to, Aborting");

            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, call was not successfull");
        return returnData;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner");
        _;
    }

    modifier sufficientBalance(uint amount) {
        require(amount <= getBalance(), "Insufficeint balance");
        _;
    }
}
