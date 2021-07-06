// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0 <0.8.0;

import "./aaveInteractor.sol";
import "./openzepplin/ERC20.sol";
import "./openzepplin/SafeMath.sol";

contract compounder {
    using SafeMath for uint256;

    ERC20 public token;
    uint256 curAmount;
    address owner;

    constructor(address _tokenAddress) public {
        token = ERC20(_tokenAddress);
        owner = msg.sender;
    }

    function compound() external {
        curAmount = token.balanceOf(address(this));
        aDeposit(token, token.balanceOf(address(this)));
        aBorrow(token, curAmount * 0.75 * 10**18);
    }

    function uncompound() external {
        aWithdraw(token, curAmount, false);
        uint256 temp = token.balanceOf(address(this)) * (4/3);
        aRepay(token, curAmount, 2, false);
        curAmount = temp;
    }

    receive() external payable {}

    function withdraw() public {
        token.transfer(owner, getBalance());
    }
}