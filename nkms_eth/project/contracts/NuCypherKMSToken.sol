/*
This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.

In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
Imagine coins, currencies, shares, voting weight, etc.
Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.

1) Initial Finite Supply (upon creation one specifies how much is minted).
2) In the absence of a token registry: Optional Decimal, Symbol & Name.
3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.

.*/
pragma solidity ^0.4.8;


import "./zeppelin/token/BurnableToken.sol";
import "./MineableToken.sol";


contract NuCypherKMSToken is MineableToken, BurnableToken {
    string public name = 'NuCypher KMS';
    uint8 public decimals = 18;
    string public symbol = 'KMS';
    string public version = '0.1';

    /**
    * @notice Set amount of tokens
    * @param _initialAmount Initial amount of tokens
    * @param _maxAmount Max amount of tokens
    **/
    function NuCypherKMSToken (uint256 _initialAmount, uint256 _maxAmount) {
        require(_maxAmount >= _initialAmount);
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        futureSupply = _maxAmount;
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }

}
