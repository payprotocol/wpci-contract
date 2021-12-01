pragma solidity ^0.8.2;

library strings {
    struct String {
        uint len;
        uint ptr;
    }
    //using assembly
    //save string byte length, memory pointer
    function toString(string memory str) internal pure returns (String memory) {
        uint ptr;
        assembly {
            ptr := add(str, 0x20)
        }
        return String(bytes(str).length, ptr);
    }
    
    function startsWith(String memory str, String memory search) internal pure returns (bool) {
        //search String must be shorter than str String 
        if (str.len < search.len) {
            return false;
        }

        bool equal;
        assembly {
            let length := mload(search)
            let strptr := mload(add(str, 0x20))
            let searchptr := mload(add(search, 0x20))
            equal := eq(keccak256(strptr, length), keccak256(searchptr, length))
        }
        return equal;
    }











}
