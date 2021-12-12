//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Lottery {
    address payable[] public players;
    address payable public admin;

    constructor() {
        admin = payable(msg.sender);
    }

    // setup rules
    receive() external payable {
        require(msg.value >= 1 ether, "Min 1 ether required");
        require(msg.sender != admin, "Admin cannot participate");

        players.push(payable(msg.sender));
    }

    // return contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // generates random int from players
    function getRandomNumber() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    // get lottery winner, transfer funds, reset lotto
    function getWinner() public {
        require(admin == msg.sender, "You are not the admin");
        require(players.length >= 3, "There must be at least 3 players");

        address payable winner;

        winner = players[getRandomNumber() % players.length];

        winner.transfer(getBalance());

        players = new address payable[](0);
    }
}
