// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Create an ERC20 Token from scratch implementing all the EIP-20 standards
 * @author Marcellus Ifeanyi
 * @notice This is a practice and further research to fully understand the ERC20 token Standard.
 *
 *  EIP-20: Token Standard
 * https://eips.ethereum.org/EIPS/eip-20
 */

contract MarsEnergyToken {
    /**
     * ============================================================ *
     * --------------------- STATE VARIABLES ------------------- *
     * ============================================================ *
     */
    string private tokenName;
    string private tokenSymbol;
    uint256 private tokenDecimals;
    uint256 tokenTotalSupply;

    address immutable i_owner;

    mapping(address account => uint256 amount) balances; // Holds the balances of an account(address) on the contract.
    mapping(address owner => mapping(address spender => uint256 amount)) allowances; // Holds the the `amount` an owner approves a spender on his behalf.

    /**
     * ============================================================ *
     * --------------------- EVENTS------------------- *
     * ============================================================ *
     */
    /**
     * @dev Emitted when `amount` tokens are moved from one account (`from`) to
     * another (`to`).
     * Note that `amount` may be zero.
     */
    event Transfer(address from, address to, uint256 amount);
    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve} ie by calling the approve() function. `amount` is the new allowance.
     */
    event Approval(address owner, address spender, uint256 amount);
    event Minted(address to, uint256 amount);
    event Burned(address to, uint256 amount);

    /**
     * ============================================================ *
     * --------------------- MODIFIERS------------------- *
     * ============================================================ *
     */

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not Owner");
        _;
    }

    /**
     * ============================================================ *
     * --------------------- FUNCTIONS------------------- *
     * ============================================================ *
     */

    /**
     * @param _tokenName: The name of the token. This is provided upon deployment of the contract.
     * @param _tokenSymbol: The symbol of the token. This is provided upon deployment of the contract.
     * @param _tokenDecimal: The token decimals. This is provided upon deployment of the contract.
     *
     * @dev the tokenName, tokenSymbol and tokenSymbol are provided upon deployment.
     */
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _tokenDecimal
    ) {
        // Initializing the state variables
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        tokenDecimals = _tokenDecimal;
        i_owner = msg.sender;
    }

    /**
     * @dev Returns the name of the token
     */
    function name() public view returns (string memory) {
        return tokenName;
    }

    /**
     * @dev Returns the symbol of the token
     */
    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * 1_000_000_000_000_000_000 = 18 decimals = 1e18
     */
    function decimals() public view returns (uint256) {
        return tokenDecimals;
    }

    /**
     * @dev Returns the total Supply of a token
     */
    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }

    /**
     * @param account: An address on the contract/blockchain which represents the user/owner
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) public view returns (uint256 balance) {
        return balances[account];
    }

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
    ) public returns (bool success) {
        // CEI Pattern: Check Effect Interaction

        // checks that the reciever's address is not a zero address
        require(to != address(0), "ERC20: transfer to the zero address");
        // checks that the sender (caller of this function) is not a zero address
        require(
            msg.sender != address(0),
            "ERC20: transfer from the zero address"
        );
        // checks that the amount to be sent is greater than zero. don't allow the user to send zero amount.
        require(amount > 0, "Increase amount");
        // checks that the balance of the sender (address `from`) is greater than or equal to amount. Don't allow user to sender morethan they have in their account.
        require(balanceOf(msg.sender) >= amount, "ERC20: Insufficient Fund");
        // subtract the amount from the balances of the sender.Debit the sender
        balances[msg.sender] -= amount;
        // add the `amount` to the balance of the receiver. Credit the receiver
        balances[to] += amount;

        success = true;

        // emit Transfer event.
        emit Transfer(msg.sender, to, amount);
    }

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
    ) public returns (bool success) {
        // sets the allowances of the `spender` to the `amount` specified by the `owner`(the caller of this function)
        allowances[msg.sender][spender] = amount;
        success = true;

        emit Approval(msg.sender, spender, amount);
    }

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
    ) public view returns (uint256 remaining) {
        return allowances[owner][spender];
    }

    /**
     * @param from: Address of the  Owner (Sender). This is the owner ie the address (account) who approved the spender.
     * @param to: Address of the Receiver. This is the  Spender ie the `account` approved by the owner to spend the token on his/her behalf.
     * @param amount: Amount of token to be sent.
     *
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     * 
     Hint: if both the addres `from` and addres `to` were provided, then anyone can call this function and it will be successful.
     */

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool success) {
        require(to != address(0), "ERC20: transfer to the zero address");

        require(from != address(0), "ERC20: transfer from the zero address");

        require(amount > 0, "Increase amount");

        require(balanceOf(from) >= amount, "ERC20: Insufficient Fund");

        // check if amount is less than or equal to allowances
        require(amount <= allowance(from, to), "Insufficient allowance");
        // subtract amount from the allowances mapping.
        allowances[from][to] -= amount;
        // subtract 'amount` from the balances of the `from` address. Debit the sender
        balances[from] -= amount;
        // add `amount` to the balances of the `to` address. Credit the receiver
        balances[to] += amount;

        // return bool success
        success = true;

        emit Transfer(from, to, amount);
    }

    // Hint: The mint and burn token function are not part of the core EIP-20 Token Standard

    function mint(address to, uint256 amount) external onlyOwner {
        require(
            to != address(0),
            "ERC20: transfer to the zero address not allowed"
        );
        // add `amount` to the totalSupply ie increase the tokenTotalSupply by `amount`.
        tokenTotalSupply += amount;

        // add `amount` to the balances of  `to` (the receiver).
        balances[to] += amount;

        emit Minted(to, amount);
    }

    function burn(address to, uint256 amount) external onlyOwner {
        require(balanceOf(msg.sender) >= amount, "Insufficient Balance");

        // subtract `amount` to the balances of  `to` (the receiver).
        balances[msg.sender] -= amount;

        // subtract `amount` from the totalSupply ie decrease the tokenTotalSupply by `amount`.
        tokenTotalSupply -= amount;

        emit Burned(to, amount);
    }

    // Question: Why do we mint and burn tokens
}
