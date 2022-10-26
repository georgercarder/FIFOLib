//SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.17;

struct FIFOElement {
    uint256 id;
    uint256 nextId;
}

struct FIFO {
    FIFOElement head; 
    FIFOElement tail;
    mapping(uint256 => FIFOElement) list;
}

library FIFOLib {

    // assuming values are non-trivial, non-repeating, unchecked
    function pushBack(FIFO storage f, uint256 value) internal {
        FIFOElement memory newElement = FIFOElement({id: value, nextId: 0});
        FIFOElement memory head = f.head;
        if (head.id != 0) {
            FIFOElement memory tail = f.tail;
            if (tail.id != 0) { // tail exists
                f.list[tail.id].nextId = value; // set old tail nextId
            } else { // tail dne
                f.head.nextId = value;
            }
            f.list[value] = newElement;  
            f.tail = newElement;
            return;
        } // else head.id == 0, so just set head
        f.head.id = value;
    }

    function popFront(FIFO storage f) internal returns(uint256 value) {
        FIFOElement memory head = f.head;
        value = head.id; // may be 0
        if (head.nextId != 0) {
            f.head = f.list[head.nextId]; 
            if (f.head.nextId != 0) return value;
            // else
            delete f.tail;
            return value;
        } // else
        delete f.head;
        return value;
    }
}
