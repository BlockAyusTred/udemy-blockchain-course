// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

contract Transaction {

    string public myString = "Hello world";

    function updateString(string memory _newString) public payable {
        if(msg.value == 1 ether) {
        myString = _newString;
        }else{
            payable(msg.sender).transfer(msg.value);
        }
    }

// fallback and receive
    // by default smart contract cannot receive anything
    // so in order to receive anything you have to one of the specific funtion - fallback or receive
    // fallback and receive function can only be external

    // the problem with the receive function is it can only rely on 2300 gas which is really low, it's called
    // gas steepened becasue if somebody sending transaction without any data.
    uint public lastValueSent;
    string public lastFuncitonCalled;

    receive() external payable {
        lastFuncitonCalled = "receive";
        lastValueSent = msg.value;
    }
    // ^here when you interact with low level transact 
    // if you only send gwei then  it will work but if you send data along with it then it will ask for fallback function


    // in  fallback function payable is optional but if you also want your fallback function to receive any value  
    fallback() external payable {
        lastFuncitonCalled = "fallback";
        lastValueSent = msg.value;
    }
    // so as of now when you call transact without any data then it will call receive funtion and if you also send 
    // the data then it will call fallback function 
    // but now if you comment out receive function and call transact without any data then what will happen it will
    // call fallback function

    uint public myUint;

    function setMyUint(uint _newUint) public {
        myUint = _newUint;
    }

    // here if you run setMyUint function and check the input data then you will get something thing like this
    // (i have given 1 in setMyUint function)

    // 0xe492fd840000000000000000000000000000000000000000000000000000000000000001
    // here the first four bytes  "e492fd84" are the funciton signatures
    // this is how internally the EVM understand what kind of funciton it should call
    // you get that four bytes by making keccach of the funciton signature 
    // the function signature is "setMyUint(uint256)"
    // web3.utils.sha3("setMyUint(uint256)")  by doing this you will get keccach of function signature
    // you will get this 0xe492fd842fb25dc4b3c624c80776108b452a545c682a78e4252b5560c6537b79  and you will notice 
    // the first four bytes are same
    // so now if you put the input data 0xe492fd84000..01 in transact (low level interaction) then it will
    // call setMyUint funtion and by changing the data like 0xe492fd84000..02  form 1 to 2 you will see the myUint will be 2
}