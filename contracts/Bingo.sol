// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bingo is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string public constant BINGO_EXTENSION = ".html";

    uint256 public maxSupply = 100;

    string public nameBingo = "";
    string public nameNomal = "";
    string public nameWinner = "";

    string public description = "";

    string public bingoAnimationURL = "";
    string public bingoImageURI = "";
    string public nomalURI = "";
    string public winnerURI = "";

    string public traitType = "";
    string public traitValueNomal = "";
    string public traitValueWinner = "";

    bool public reveal = false;

    mapping (uint256 => bool) public winnerList;
 
    constructor(
        string memory _initBingoAnimationURL,
        string memory _initBingoImageURI,
        string memory _initNomalURI,
        string memory _initWinnerURI,
        string memory _initNameBingo,
        string memory _initNameNomal,
        string memory _initNameWinner
    ) ERC721("NFT Bingo", "BINGO") {
        setBingoAnimationURL(_initBingoAnimationURL);
        setBingoImageURI(_initBingoImageURI);
        setNomalURI(_initNomalURI);
        setWinnerURI(_initWinnerURI);
        setNameBingo(_initNameBingo);
        setNameNomal(_initNameNomal);
        setNameWinner(_initNameWinner);
    }

    function mintNFT(uint256 _quantity) public onlyOwner {
        require(totalSupply() + _quantity <= maxSupply, "Exceed supply");

        for (uint256 i = 0; i < _quantity; i++){
            uint256 supply = totalSupply();
            _safeMint(msg.sender, supply + 1);
        }
    }

    function sendNFT(address[] memory _to) public onlyOwner {
        require(totalSupply() + _to.length <= maxSupply, "Exceed supply");
        for (uint256 i = 0; i < _to.length; i++){
            uint256 supply = totalSupply();
            _safeMint(_to[i], supply + 1);
        }
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    } 

    function setNameNomal(string memory _nameNomal) public onlyOwner {
        nameNomal = _nameNomal;
    }

    function setNameWinner(string memory _nameWinner) public onlyOwner {
        nameWinner = _nameWinner;
    }

    function setNameBingo(string memory _nameBingo) public onlyOwner {
        nameBingo = _nameBingo;
    }

    function setDescription(string memory _description) public onlyOwner {
        description = _description;
    }

    function setBingoAnimationURL(string memory _bingoAnimationURL) public onlyOwner {
        bingoAnimationURL = _bingoAnimationURL;
    }

    function setBingoImageURI(string memory _bingoImageURI) public onlyOwner {
        bingoImageURI = _bingoImageURI;
    }

    function setNomalURI(string memory _nomalURI) public onlyOwner {
        nomalURI = _nomalURI;
    }

    function setWinnerURI(string memory _winnerURI) public onlyOwner {
        winnerURI = _winnerURI;
    }
    
    function setTraitType(string memory _traitType) public onlyOwner {
        traitType = _traitType;
    }

    function setTraitValueNomal(string memory _traitValueNomal) public onlyOwner {
        traitValueNomal = _traitValueNomal;
    }

    function setTraitValueWinner(string memory _traitValueWinner) public onlyOwner {
        traitValueWinner = _traitValueWinner;
    }

    function setReveal(bool _status) public onlyOwner {
        reveal = _status;
    }

    function addWinnerList(uint256[] memory _tokenIds) public onlyOwner {        
        for (uint256 i; i < _tokenIds.length; i++) {
            winnerList[_tokenIds[i]] = true;
        }
    }

    function deleteWinnerList(uint256[] memory _tokenIds) public onlyOwner{
        for (uint256 i; i < _tokenIds.length; i++) {
            delete winnerList[_tokenIds[i]];
        }
    }

    function revealedURI(uint256 tokenId) public view returns (string memory) {
        require(reveal, "Not reveal");
        require(_exists(tokenId), "NFT Bingo: Nonexistent token");

        string memory name;
        string memory image;
        string memory value;

        if (!winnerList[tokenId]) {
            name = string(abi.encodePacked(nameNomal, " #", tokenId.toString()));
            image = nomalURI;
            value = traitValueNomal;
        } else {
            name = string(abi.encodePacked(nameWinner, " #", tokenId.toString()));
            image = winnerURI;
            value = traitValueWinner;
        }

        string memory json = string(
            abi.encodePacked('data:application/json;base64,',
                Base64.encode(bytes(abi.encodePacked(
                    '{"name":"', name,
                    '", "description": "', description,
                    '", "image" : "', image,
                    '", "attributes" : [{"trait_type": "', traitType,'", "value": "', value,
                    '"}]}'
                )))
            )
        );

        return json;
    }


    function notRevealedURI(uint256 tokenId) public view returns(string memory) {
        require(!reveal, "Reveal now");
        require(_exists(tokenId), "NFT Bingo: Nonexistent token");

        string memory name = string(abi.encodePacked(nameBingo, " #", tokenId.toString()));

        string memory json = string(
            abi.encodePacked('data:application/json;base64,',
                Base64.encode(bytes(abi.encodePacked(
                    '{"name":"', name,
                    '", "description": "', description,
                    '", "image" : "', bingoImageURI,
                    '", "animation_url" : "', bingoAnimationURL, tokenId.toString(), BINGO_EXTENSION,
                    '"}'
                )))
            )
        );
        
        return json;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "NFT Bingo: Nonexistent token");

        if (!reveal) {
            return notRevealedURI(tokenId);
        } 

        return revealedURI(tokenId);
    }
}