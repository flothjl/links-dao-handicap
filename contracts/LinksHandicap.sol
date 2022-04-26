// contracts/LinksHandicap.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract LinksHandicap is Ownable {
    // Emitted when the stored value changes
    event ScoreAdded(
        address indexed who,
        int8 indexed score,
        string courseName
    );

    struct Score {
        uint256 scoretime;
        int8 score;
        string courseName;
    }

    mapping(address => Score[]) scores;
    mapping(address => uint256) ownerScoreCount;

    IERC721 linksDao = IERC721(0x696115768BBEf67Be8bd408d760332A7EfbEE92D);

    function setLinksDaoContract(address _address) public onlyOwner {
        linksDao = IERC721(_address);
    }

    modifier onlyLinksOwner() {
        require(linksDao.balanceOf(msg.sender) > 0, "Unauthorized");
        _;
    }

    function addScore(
        int8 value,
        uint256 scoretime,
        string memory courseName
    ) public onlyLinksOwner {
        scores[msg.sender].push(Score(scoretime, value, courseName));

        ownerScoreCount[msg.sender]++;

        emit ScoreAdded(msg.sender, value, courseName);
    }

    function addScoreBatch(Score[] memory _scores) public {
        for (uint256 i = 0; i < _scores.length; i++) {
            addScore(
                _scores[i].score,
                _scores[i].scoretime,
                _scores[i].courseName
            );
        }
    }

    function getScoresByOwner(address _address)
        public
        view
        returns (Score[] memory)
    {
        return scores[_address];
    }

    function getScoreCountByOwner(address _address)
        public
        view
        returns (uint256)
    {
        return ownerScoreCount[_address];
    }
}
