//SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FIFOLib.sol";

contract FIFOTest is Test {
    using FIFOLib for FIFO;

    address constant testProvider = address(69);
    uint256 constant testVersion = 420;

    FIFO public f;

    function setUp() public {
    }

    function testSingle(uint256 x) public {
        // since FIFO assume non-zero vals
        x = (x == 0) ? uint256(keccak256(abi.encodePacked(x))) : x;
        uint256 value = x;
        f.pushBack(value);
        uint256 resValue = f.popFront();
        assertEq(resValue, value);
        assertEq(f.popFront(), 0);

        // run again
        value = uint256(keccak256(abi.encodePacked(value))); // mix it up bro

        f.pushBack(value);
        resValue = f.popFront();
        assertEq(resValue, value);
        assertEq(f.popFront(), 0);
    }

    function testDouble(uint256 x, uint256 y) public {
        uint256[2] memory values;
        // since FIFO assume non-zero vals
        x = (x == 0) ? uint256(keccak256(abi.encodePacked(x))) : x;
        y = (y == 0) ? uint256(keccak256(abi.encodePacked(y))) : y;
        //
        values[0] = x;
        values[1] = y;
        f.pushBack(values[0]);
        f.pushBack(values[1]);
        uint256[2] memory resValues;
        resValues[0] = f.popFront();
        resValues[1] = f.popFront();
        for (uint256 i; i < 2; ++i) {
            assertEq(resValues[i], values[i]);
        }
        assertEq(f.popFront(), 0);

        // run again

        values[0] = uint256(keccak256(abi.encodePacked(values[0])));
        values[1] = uint256(keccak256(abi.encodePacked(values[1])));

        f.pushBack(values[0]);
        f.pushBack(values[1]);
        resValues[0] = f.popFront();
        resValues[1] = f.popFront();
        for (uint256 i; i < 2; ++i) {
            assertEq(resValues[i], values[i]);
        }
        assertEq(f.popFront(), 0);
    }

    function testMultiple() public {
        uint256 bound = 7;
        uint256[] memory values = new uint256[](bound);
        for (uint256 i; i < bound; ++i) {
            values[i] = uint256(keccak256(abi.encodePacked(i))); 
        }
        for (uint256 i; i < bound; ++i) {
            f.pushBack(values[i]);
        }
        uint256[] memory resValues = new uint256[](bound);
        for (uint256 i; i < bound; ++i) {
            resValues[i] = f.popFront();
        }
        for (uint256 i; i < bound; ++i) {
            assertEq(resValues[i], values[i]);
        }
        assertEq(f.popFront(), 0);

        // run again
        for (uint256 i; i < bound; ++i) {
            values[i] = uint256(keccak256(abi.encodePacked(values[i])));
        }

        for (uint256 i; i < bound; ++i) {
            f.pushBack(values[i]);
        }
        for (uint256 i; i < bound; ++i) {
            resValues[i] = f.popFront();
        }
        for (uint256 i; i < bound; ++i) {
            assertEq(resValues[i], values[i]);
        }
        assertEq(f.popFront(), 0);
    }
}
