// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract WPCI is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant WRAPPER_ROLE = keccak256("WRAPPER_ROLE");

    mapping(bytes32 => bool) private _extIDs;

    event Wrapped(address indexed to, uint256 amount, bytes32 indexed extID);

    event Unwrapped(address indexed from, uint256 amount, string extTo);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() public initializer {
        __initialize(msg.sender);
    }

    function initialize(address wrapper) public initializer {
        __initialize(wrapper);
    }

    function __initialize(address wrapper) internal {
        __ERC20_init("Wrapped PCI", "WPCI");
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
        _setupRole(WRAPPER_ROLE, wrapper);
    }

    function decimals() public pure override returns (uint8) {
        return 8;
    }

    function cap() public pure returns (uint256) {
        return 394100000000000000;  // 3941000000 * 10 ** decimals()
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev Returns `true` if `extID` has been wrapped.
     */
    function wrapped(bytes32 extID) public view returns (bool) {
        return _extIDs[extID];
    }

    /**
     * @dev Wrap
     *
     * Emits {Wrapped} and {IERC20-Transfer} events.
     */
    function wrap(address to, uint256 amount, bytes32 extID) public onlyRole(WRAPPER_ROLE) returns (bool) {
        require(!wrapped(extID), "Wrapper: already wrapped external ID");
        require(amount > 0, "Wrapper: zero amount");

        _extIDs[extID] = true;
        _mint(to, amount);

        emit Wrapped(to, amount, extID);

        return true;
    }
    
    /**
     * @dev Unwrap
     *
     * Emits {Unwrapped} and {IERC20-Transfer} events.
     */
    function unwrap(string memory extTo, uint256 amount) public returns (bool) {
        require(_isPCIAddress(extTo), "Wrapper: invalid PCI address");
        require(amount > 0, "Wrapper: zero amount");

        _burn(_msgSender(), amount);

        emit Unwrapped(_msgSender(), amount, extTo);

        return true;
    }

    // PCI address must be 53 bytes and starts with 'PCI', not case-sensitive.
    function _isPCIAddress(string memory addr) internal pure returns (bool) {
        bytes memory addrBytes = bytes(addr);
        return addrBytes.length == 53 &&
            ((addrBytes[0] == 0x50) || (addrBytes[0] == 0x70)) &&  // 'P' or 'p'
            ((addrBytes[1] == 0x43) || (addrBytes[1] == 0x63)) &&   // 'C' or 'c'
            ((addrBytes[2] == 0x49) || (addrBytes[2] == 0x69));    // 'I' or 'i'
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal override {
        require(ERC20Upgradeable.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {}
}
