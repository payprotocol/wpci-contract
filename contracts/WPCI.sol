// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./pci.sol";

contract WPCI is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant WRAPPER_ROLE = keccak256("WRAPPER_ROLE");

    mapping(bytes32 => bool) private _extIDs;

    using pci for *;

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

    function decimals() public view virtual override returns (uint8) {
        return 8;
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
        require(extTo.isValidate(), "Wrapper: invalid extTo");
        require(amount > 0, "Wrapper: zero amount");

        _burn(_msgSender(), amount);

        emit Unwrapped(_msgSender(), amount, extTo);

        return true;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {}
}
