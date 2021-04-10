# smart-contract

Chainlink Virtual Hackathon Spring 2021

Smart contracts were installed in The Kovan Testnet.

### Component addresses:
* AquaProtocol: 0xd43DDE8c0fa617Fe7E8Ac53e8D17684F8F0FE75b
* Treasury: 0x843836D5fe2c9FbbcDa9711BD36046cD0975769f
* BankFunctionOrcle: 0x5E86eB0041a9a82164537e92319ddcF6853cfC75
* Insurance: 0xADf4743a95F0C6203E0Fbc0422576C3ea8d3CE4c
* Picture: 0x7D26A96ee38Cc0a6594ecd710446c1B3E16fF625
* Paper: 0xB4847e27c45D2c73C89A78b68B631330B6567854
* PLCurrency: 0x4e52b55514fd23f2f86926230efc8a5c0a694418

### AquaProtocol

The protocol allows on buying investments possibilities as the stock paper, the insurance, or the art in the Euro currency. To this, the Chainlink oracle with the [requestEuroPrice](https://github.com/aquaprotocol/smart-contract/blob/69869994495a515af67855448b200e7798138dc7/AquaProtocol.sol#L83) function is used. The function feeds Euro price from fake web service. 


Short function description:

#### Deposit
Deposit stablecoin/crypto currency
```solidity
    function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf
  ) external {}
```
#### DepositFiat
Deposit fiat currency
```solidity
    function depositFiat(
    address asset,
    uint256 amount,
    string calldata bankAccountAddress,
    address ethAddress
  ) external {}
```

#### Withdraw
Withdraw stable coin/cryptocurrency

```solidity
function withdraw(
    address asset,
    address ethAddress,
    uint256 amount,
    address onBehalfOf
  ) external {}
```

#### WithdrawFiat
Withdraw fiat currency
```solidity
function withdrawFiat(
    address asset,
    address ethAddress,
    string calldata bankAccountAddress,
    uint256 amount,
    address onBehalfOf
  ) external {}
```
#### BuyPaper
  Function for Paper investment
```solidity
function buyPaper(
    address asset,
    address tokenAddress,
    address operator,
    uint256 amount,
    string memory issuerId,
    string memory series,
    uint256 numberFrom,
    uint256 numberTo
    ) public {}
```
#### BuyArt
  Function for Art investment
```solidity
function buyArt(
    address asset,
    address tokenAddress,
    address operator,
    uint256 amount,
    string memory name
    ) public {}
```
#### BuyInsurance
  Function for Insurance investment
```solidit
function buyInsurance(
    address asset,
    address tokenAddress,
    address operator,
    uint256 amount,
    string memory name,
    string memory _typeOf,
    string memory _date
    ) public {}
```

#### CallbackDepositFiat
The Function invoked by the BankFunctionOracle for set state after the Oracle OpenBanking API service use.
```solidity
function callbackDepositFiat(string memory _result, uint256 _id) public onlyOracle {}
```
#### CallbackWithdrawFiat
The Function invoked by the BankFunctionOracle for set state after the Oracle OpenBanking API service use.
```solidity
function callbackWithdrawFiat(string memory _result, uint256 _id) public onlyOracle {}
```

### BankFunctionOracle
The Smart contract uses the Oracle OpenBanking API.

#### InvokeFiatDeposit
Fiat deposition api. Invoke in AquaProtocol depositFiat function.
```solidity
function invokeFiatDeposit(uint256 _amount, string memory _bankAccountNumber) public returns (uint256) {}
```
#### InvokeFiatWithdraw
The Fiat withdrew the api. Invoke in AquaProtocol depositFiat function.
```solidity
function invokeFiatWithdraw(uint256 _amount, string memory _bankAccountNumber) public returns (uint256) {}
```
#### SetFiatDepositResult
Function invoke by Oracle API, for set deposit result state
```solidity
function SetFiatDepositResult(string memory _result, address _callerAddress, uint256 _id) public onlyOwner {}
```

#### SetFiatWithdrawResult
Function invoke by Oracle API, for set withdraw result state
```solidity
function SetFiatWithdrawResult(string memory _result, address _callerAddress, uint256 _id) public onlyOwner {}
```

### ERC-20 smart contract implementation
Treasury, PLCurrenct


### ERC-721 smart contract implementation
Art, Paper, Insurance
