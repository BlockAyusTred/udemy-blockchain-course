// SPDX-License-Identifier: SPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

    constructor(uint256 initialSupply) ERC20("StartDucks Cappucino Token", "CAPPU") public {
        _mint(msg.sender,initialSupply);
    }

    function decimals() public view override returns (uint8) {
        return 0;
    }
}

 
