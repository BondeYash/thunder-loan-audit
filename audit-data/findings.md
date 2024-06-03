### [H-1] Erroneous `Thunderloan::updateExchnageRate` in the ``ThunderLoan::deposit` causes the block the reedemption and causes for incorrect exchange rate

**Description:** The ThunderLoan system has an errorneous exchange rate in a `ThunderLoan::deposit`
function that cuases the block in the reddemption of the funds .

In a way the deposit function updates the exchangeRate without really adding fees. This update should be removed 
```diff
   function deposit(IERC20 token, uint256 amount) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) / exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);

        // @audit-high em got it ! This wierd kind of updating the exchange rate makes user fail to redeem money
@>        uint256 calculatedFee = getCalculatedFee(token, amount);
@>        assetToken.updateExchangeRate(calculatedFee);


        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }
```

**Impact:** There are several impacts to this bug 

1. The `reddem` function has been blocked because protocol thinks it has more tokens tham actually it has
2. Rewards are incorrectly calculated for liquidity providers
**Proof of Concept:**

```javascript
 function testReedemFunction () public setAllowedToken hasDeposits {
        uint256 amountToBorrow = AMOUNT * 10;
        uint256 calculatedFee = thunderLoan.getCalculatedFee(tokenA, amountToBorrow);
        vm.startPrank(user);
        tokenA.mint(address(mockFlashLoanReceiver), calculatedFee);
        thunderLoan.flashloan(address(mockFlashLoanReceiver), tokenA, amountToBorrow, "");
        vm.stopPrank();

        uint256 amounttoReedem = type(uint256).max;

        vm.startPrank(liquidityProvider);
        thunderLoan.redeem(tokenA , amounttoReedem);
    }

```

**Recommended Mitigation:** Remove those two wierd lines of updating exchange rate
```diff
   function deposit(IERC20 token, uint256 amount) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) / exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);

        // @audit-high em got it ! This wierd kind of updating the exchange rate makes user fail to redeem money
-       uint256 calculatedFee = getCalculatedFee(token, amount);
-        assetToken.updateExchangeRate(calculatedFee);


        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }

```