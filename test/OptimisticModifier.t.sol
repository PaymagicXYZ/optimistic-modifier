// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "../src/OptimisticModifier.sol";
import "../src/test/TestAvatar.sol";
import "../src/test/Mock.sol";
import "forge-std/Test.sol";

contract OptimisticModifierTest is Test {
    address alice = address(0x42);

    Mock mock;
    TestAvatar avatar;
    OptimisticModifier optimisticModifier;
    uint256 reimbursementFee = 0.01 ether;

    function setUp() public {
        // vm.startPrank(alice);
        avatar = new TestAvatar();
        mock = new Mock();

        vm.deal(address(avatar), 1000 ether);

        optimisticModifier = new OptimisticModifier(
            alice,
            address(avatar),
            address(avatar),
            1,
            0,
            reimbursementFee
        );

        avatar.setModule(address(optimisticModifier));
    }

    function testExample(
        address payable to,
        // uint256 value,
        bytes calldata data
    ) public {
        vm.startPrank(alice);
        optimisticModifier.enableModule(alice);

        bytes memory encoded = abi.encodeWithSignature(
            "exec(address,uint256,bytes)",
            to,
            0,
            data
        );

        optimisticModifier.execTransactionFromModule(
            address(mock),
            0,
            encoded,
            Enum.Operation.Call
        );

        skip(1);

        assertEq(alice.balance, 0);

        uint256 gas = gasleft();
        optimisticModifier.executeNextTxReimburse(
            address(mock),
            alice,
            0,
            encoded,
            Enum.Operation.Call
        );
        uint256 left = (gas - gasleft()) * tx.gasprice;

        assertApproxEqRel(alice.balance, left + reimbursementFee, 1e7);
    }
}
