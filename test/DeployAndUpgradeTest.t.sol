// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../../script/DeployBox.s.sol";
import {UpgradeBox} from "../../script/UpgradeBox.s.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {BoxV2} from "../../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployBox;
    UpgradeBox public upgradeBox;
    address public OWNER = makeAddr("owner");

    address public proxy;
    BoxV2 public boxV2;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
        proxy = deployBox.run(); // points to boxV1
    }

    function testProxyStartAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(1);
    }

    function testUpgrade() public {
        boxV2 = new BoxV2();

        upgradeBox.upgradeBox(proxy, address(boxV2));
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }
}
