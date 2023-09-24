// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import { ITSwapPool } from "../interfaces/ITSwapPool.sol";
import { IPoolFactory } from "../interfaces/IPoolFactory.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract OracleUpgradeable is Initializable {
    address private s_tswap;

    function __Oracle_init(address tswapAddress) internal onlyInitializing {
        __Oracle_init_unchained(tswapAddress);
    }

    function __Oracle_init_unchained(address tswapAddress) internal onlyInitializing {
        s_tswap = tswapAddress;
    }

    function getPriceInWeth(address token) public view returns (uint256) {
        address swapPoolOfToken = IPoolFactory(s_tswap).getPool(token);
        return ITSwapPool(swapPoolOfToken).getPriceOfOnePoolTokenInWeth();
    }

    function getPrice(address token) external view returns (uint256) {
        return getPriceInWeth(token);
    }
}
