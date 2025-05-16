// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title DEX
 * @dev A simple decentralized exchange for swapping tokens
 */
contract DEX is Ownable, ReentrancyGuard {
    // Mapping from token address to its balance in the DEX
    mapping(address => uint256) public tokenBalances;
    
    // Mapping to keep track of supported tokens
    mapping(address => bool) public supportedTokens;
    
    // Fee percentage (in basis points, 100 = 1%)
    uint256 public feePercent = 30; // 0.3% fee
    
    // Events
    event TokenAdded(address indexed tokenAddress);
    event TokenRemoved(address indexed tokenAddress);
    event LiquidityAdded(address indexed provider, address indexed tokenAddress, uint256 amount);
    event LiquidityRemoved(address indexed provider, address indexed tokenAddress, uint256 amount);
    event Swap(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Add support for a new token
     * @param _tokenAddress The address of the token to add
     */
    function addSupportedToken(address _tokenAddress) external onlyOwner {
        require(_tokenAddress != address(0), "Invalid token address");
        require(!supportedTokens[_tokenAddress], "Token already supported");
        
        supportedTokens[_tokenAddress] = true;
        emit TokenAdded(_tokenAddress);
    }
    
    /**
     * @dev Remove support for a token
     * @param _tokenAddress The address of the token to remove
     */
    function removeSupportedToken(address _tokenAddress) external onlyOwner {
        require(supportedTokens[_tokenAddress], "Token not supported");
        
        supportedTokens[_tokenAddress] = false;
        emit TokenRemoved(_tokenAddress);
    }
    
    /**
     * @dev Add liquidity to the exchange
     * @param _tokenAddress The address of the token to add liquidity for
     * @param _amount The amount of tokens to add
     */
    function addLiquidity(address _tokenAddress, uint256 _amount) external nonReentrant {
        require(supportedTokens[_tokenAddress], "Token not supported");
        require(_amount > 0, "Amount must be greater than 0");
        
        IERC20 token = IERC20(_tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        tokenBalances[_tokenAddress] += _amount;
        emit LiquidityAdded(msg.sender, _tokenAddress, _amount);
    }
    
    /**
     * @dev Remove liquidity from the exchange
     * @param _tokenAddress The address of the token to remove liquidity from
     * @param _amount The amount of tokens to remove
     */
    function removeLiquidity(address _tokenAddress, uint256 _amount) external onlyOwner nonReentrant {
        require(supportedTokens[_tokenAddress], "Token not supported");
        require(_amount > 0, "Amount must be greater than 0");
        require(tokenBalances[_tokenAddress] >= _amount, "Insufficient liquidity");
        
        IERC20 token = IERC20(_tokenAddress);
        require(token.transfer(msg.sender, _amount), "Transfer failed");
        
        tokenBalances[_tokenAddress] -= _amount;
        emit LiquidityRemoved(msg.sender, _tokenAddress, _amount);
    }
    
    /**
     * @dev Swap tokens
     * @param _tokenIn The address of the token to swap from
     * @param _tokenOut The address of the token to swap to
     * @param _amountIn The amount of tokens to swap
     * @return amountOut The amount of tokens received
     */
    function swap(address _tokenIn, address _tokenOut, uint256 _amountIn) external nonReentrant returns (uint256 amountOut) {
        require(supportedTokens[_tokenIn], "Input token not supported");
        require(supportedTokens[_tokenOut], "Output token not supported");
        require(_amountIn > 0, "Amount must be greater than 0");
        require(_tokenIn != _tokenOut, "Cannot swap same token");
        
        // Calculate the amount of tokens to receive (simple constant product formula)
        uint256 reserveIn = tokenBalances[_tokenIn];
        uint256 reserveOut = tokenBalances[_tokenOut];
        
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");
        
        // Calculate output amount using x * y = k formula
        // Applying the fee: amountInWithFee = amountIn * (10000 - fee) / 10000
        uint256 amountInWithFee = (_amountIn * (10000 - feePercent)) / 10000;
        
        // Calculate the output amount: (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee)
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);
        
        require(amountOut > 0, "Insufficient output amount");
        require(amountOut <= reserveOut, "Insufficient output reserve");
        
        // Transfer tokens from user to DEX
        IERC20 tokenIn = IERC20(_tokenIn);
        IERC20 tokenOut = IERC20(_tokenOut);
        
        require(tokenIn.transferFrom(msg.sender, address(this), _amountIn), "Transfer in failed");
        require(tokenOut.transfer(msg.sender, amountOut), "Transfer out failed");
        
        // Update reserves
        tokenBalances[_tokenIn] += _amountIn;
        tokenBalances[_tokenOut] -= amountOut;
        
        emit Swap(msg.sender, _tokenIn, _tokenOut, _amountIn, amountOut);
        return amountOut;
    }
    
    /**
     * @dev Get the current exchange rate between two tokens
     * @param _tokenIn The address of the input token
     * @param _tokenOut The address of the output token
     * @param _amountIn The amount of input tokens
     * @return The amount of output tokens you would receive
     */
    function getExchangeRate(address _tokenIn, address _tokenOut, uint256 _amountIn) public view returns (uint256) {
        require(supportedTokens[_tokenIn], "Input token not supported");
        require(supportedTokens[_tokenOut], "Output token not supported");
        require(_amountIn > 0, "Amount must be greater than 0");
        
        uint256 reserveIn = tokenBalances[_tokenIn];
        uint256 reserveOut = tokenBalances[_tokenOut];
        
        if (reserveIn == 0 || reserveOut == 0) {
            return 0;
        }
        
        uint256 amountInWithFee = (_amountIn * (10000 - feePercent)) / 10000;
        return (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);
    }
}
