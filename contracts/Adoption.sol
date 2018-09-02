pragma solidity ^0.4.22;

// interface for ERC20 token
contract ERC20_PTT_Interface {
    function totalSupply() public view returns (uint _totalSupply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public pure returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract Adoption {

    // declare token
    ERC20_PTT_Interface public ptt;

    // token contract address here
    address private tracker_0x_address = 0x253B4E6CB5D787b557760E19C2D2C728BE4e10bE; // ContractA Address

    address[16] public adopters;
    address private owner;

    constructor() public {
        owner = msg.sender;
        // set the token instance at first
        ptt = ERC20_PTT_Interface(tracker_0x_address);
    }
    
    modifier onlyOwner() {
        require (msg.sender == owner, "Not Owner");
        _;
    }

    modifier onlyBuyer() {
        require (msg.sender != owner, "Not Buyer");
        _;
    }
    
    // adopting a pet
    function adopt(uint petId, uint tokens) public onlyBuyer payable returns (uint)
    {
        require((petId>=0 && petId<=15), "PetId Error");

        // transfrom tokens from sender to this contract
        require(ptt.transferFrom(msg.sender, address(this), tokens), "Transform Error");

        adopters[petId] = msg.sender;
        
        return petId;
    }

    // withdraw all income
    function withdraw() public onlyOwner returns(bool){
        require(ptt.balanceOf(this) > 0, "balance 0");
        // equal: contract.transfer(from = this contract, to = owner, value)
        require(ptt.transfer(owner, ptt.balanceOf(this)), "transfer error");
        return true;
    }
    
    // retrieveing the adopters
    function getAdopters() public view returns (address[16])
    {
        return adopters;
    }
    
    function getPetPrice(uint petId) public pure returns (uint256)
    {
        return (petId + 1) * 100;
    }
    
    // retrieveing the balance of this contract
    function getBalanceContract() public view returns(uint256){
        return ptt.balanceOf(this);
    }
}
