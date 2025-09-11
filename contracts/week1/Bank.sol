// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface IBank {
    function getTop3() external view returns(address[3] memory);
    function getBalance() external view returns(uint);
    function withdraw(address payable requestAddr) external payable;
}

contract Bank {
  mapping(address => uint) balances;
  address[3] top3;
  address admin;

  constructor(){
    admin = msg.sender;
  }

  receive() external payable { 
    deposit();
    
  }

  // 实现IBank接口的deposit方法
  function deposit() public virtual payable {
    balances[msg.sender] += msg.value; // transfer ether

    for(uint i=0;i<3;i++){
      address currentAddr = top3[i];
      if(currentAddr == address(0)){
        top3[i] = msg.sender;
        break;
      }
      uint balance = balances[currentAddr];
      if(balance > balances[msg.sender]){
        continue;
      }else{
        for(uint j=2;j>i;j--){
          top3[j] = top3[j-1];
        }
        top3[i] = msg.sender;
        break;
      }
      
    }
  }

  // 实现IBank接口的getBalance方法
  function getBalance() public view returns(uint) {
   return balances[msg.sender];
  }

  // 实现IBank接口的getTop3方法
  function getTop3() public view returns(address[3] memory) {
    return top3;
  }

  function setAdmin() public {
    require(admin == msg.sender,"only admin can do this");
    admin = msg.sender;
  }

  function getTop3Addr(uint index) public view returns (address){
    require(index<=2,"invalid index");
    return top3[index];
  }

  function withdraw(address payable requestAddr) public payable onlyAdmin(requestAddr) {
    uint balance = address(this).balance;
    require(balance>0,"no funds to withdraw");
    requestAddr.transfer(balance);
  }

  // 转移管理员权限
  function transferAdmin(address newAdmin) public {
      require(newAdmin != address(0), "Invalid admin address");
      admin = newAdmin;
  }

  modifier onlyAdmin(address payable requestAddr){
    require(requestAddr == admin,"only admin can do this");
    _;
  }
}

// Admin合约
contract Admin {
    address public owner;

    // 构造函数设置合约部署者为owner
    constructor() {
        owner = msg.sender;
    }

    // 只有owner可以调用的修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // 从银行合约取款到本Admin合约
    function adminWithdraw(IBank bank) external onlyOwner {
        // 调用银行合约的withdraw方法，将资金转移到本合约
        bank.withdraw(payable(address(this)));
    }

    // 允许Admin合约接收以太币
    receive() external payable {}
}
