// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IMarsEnergyToken {
    /**
     * @dev Returns the name of the token
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     */
    function decimals() external view returns (uint256);

    /**
     * @dev Returns the total Supply of a token
     */
    function totalSupply() external view returns (uint256);

    /**
     * @param account: An address on the contract/blockchain which represents the user/owner
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256 balance);

    /**
     * @param to: Account address of the Receiver
     * @param amount: Amount of token to be Sent to the Receiver.
     *
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */

    function transfer(
        address to,
        uint256 amount
    ) external returns (bool success);

    /**
     * @param from: Address of the  Owner (Sender)
     * @param to: Address of the Receiver
     * @param amount: Amount of token to be sent.
     *
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool success);

    /**
     * @param spender: Address of the spender
     * @param amount: Amount to be spent
     *
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     */
    function approve(
        address spender,
        uint256 amount
    ) external returns (bool success);

    /**
     * @param owner: Address of the owner
     * @param spender: Address of the spender
     *
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256 remaining);
}
