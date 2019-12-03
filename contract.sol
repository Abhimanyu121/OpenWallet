pragma solidity ^0.5.2;
contract MeWallet{
    mapping(string=>address) phoneNo;
    function getNo(string memory phone)  public view returns(address){
       address addr =  phoneNo[phone];
       return addr;
        
    }
    function setNo(string memory phone) public  {
        phoneNo[phone] = msg.sender;
    }
} 