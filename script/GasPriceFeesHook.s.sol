// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GasPriceFeesHook} from "../src/GasPriceFeesHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {PoolManager} from "v4-core/PoolManager.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";

contract DeployGasPriceFeesHook is Script {
    GasPriceFeesHook hook;
    PoolManager manager;

    function setUp() public {}

    function run() public {
        // Load the private key for deployment
        vm.startBroadcast();

        // Deploy the PoolManager if not already deployed
        // In a real scenario, you might use an already deployed PoolManager
        manager = new PoolManager();

        // Calculate the hook address with proper flags
        address hookAddress = address(
            uint160(
                Hooks.BEFORE_INITIALIZE_FLAG |
                    Hooks.BEFORE_SWAP_FLAG |
                    Hooks.AFTER_SWAP_FLAG
            )
        );

        // Deploy the hook contract to the calculated address
        deployCodeTo(
            "GasPriceFeesHook.sol",
            abi.encode(address(manager)),
            hookAddress
        );

        hook = GasPriceFeesHook(hookAddress);

        vm.stopBroadcast();

        console.log("GasPriceFeesHook deployed at:", address(hook));
        console.log("PoolManager deployed at:", address(manager));
        console.log("Initial moving average gas price:", hook.movingAverageGasPrice());
        console.log("Initial moving average count:", hook.movingAverageGasPriceCount());
    }
}