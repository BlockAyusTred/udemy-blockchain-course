// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Example {

// Boolean Example
    bool public myBool;

    /**
    if you input nothing and first test what is the value then it will be false because the default value of boolean is false
    if you put true or any integer even 0 then it will interpret it as TRUE
    */
    function setMyBool(bool _bool) public {
        myBool = _bool;
    }

// Uint Example
    uint public myUint; // 0 to (2^256)-1

    /**
    * uint is alias of uint256 it can store value from 0 upto 2^256 -1
    * in previous version if it hits it's maximum value then it will be reverted to 0 but now it 
      is not the case
    * after version 0.8 if it hits maximum or minimum value then it will not revert it 
    * but if you want to use >0.8 version and also want to use reverted feature which is in lesser
      version then you can just wrap the variable in unchecked
    */
    function setMyUint(uint _uint) public {
        myUint = _uint;
    }
    function decrementUint() public {
        unchecked{
            myUint--;
        }
    }

    int public myInt= -10; // -2^128  to  2^128


// String Example
    // Strings are expensive to store on blockchain

    string public myString = "Hello World";
    bytes public myBytes = "Hello World";
    // techinically string and bytes are same but there are differences 
    // you can calculate lengths in bytes

    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    function compareTwoString(string memory _myString) public view returns(bool) {
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

// Address

    // address types are storing 20 bytes worth of an Ethereum address or Ethereum account
    address public someAddress; // by default is 0x000000... 

    function setSomeAddress(address _someAddress) public {
        someAddress = _someAddress;
    }

    function getBalance() public view returns(uint) {
        return someAddress.balance;
    }

// msg.

    function updateAddress() public {
        someAddress = msg.sender;
    }

// view and pure
    // the major differnce between view and pure function is view function can access storeage variable or global variable but pure can't
    uint public myVariable;

    function getMyvariable() public view returns(uint) {
        return myVariable;
    }

    function getAddition(uint a, uint b) public pure returns(uint) {
        return a+b;
    }

    // for writing function 

    function setMyVariable(uint _myVariable) public {
        myVariable = _myVariable;
    }
    // you generally don't use return funciton in real blockchain (outside of javascript environment) instead you use events
    // so remember that writng function don't have return function it they have then it's only meant for other smart contracts,
    // you cannot get output over here


//  constructor

     // A constructor is a spacial function it doesnt have function keyword, it accepts any kind of arguments
     // the special thing aobut constructor is it is directly called during the deployment of smart contract 

     address public myAddress;

     constructor(address _someAddress) {
         myAddress = _someAddress;
     }

}