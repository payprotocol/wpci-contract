pragma solidity ^0.8.2;
library pci {
    
    function isValidate(string memory account) internal pure returns (bool) {
        bytes memory accountBytes = bytes(account);
        bytes memory lower = bytes("pci");
        bytes memory upper = bytes("PCI");
        //pci account must be 53 bytes and starts with 'pci' or 'PCI'
        return accountBytes.length == 53 && (startsWith(accountBytes, lower) || startsWith(accountBytes, upper));
    }

    function startsWith(bytes memory str, bytes memory key) internal pure returns (bool) {
        uint len = key.length;
        for (uint i=0; i<len; i++) {
            if(str[i] != key[i]) {
                return false;
            }
        }
        return true;
    }
}