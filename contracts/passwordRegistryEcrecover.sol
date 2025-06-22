// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PasswordRegistryPlus {
    mapping(address => string) private userHashes;

    //esempi possibili eventi, smart contract comunica con essi all'esterno  
    event HashRegistered(address indexed user, string hash);
    event HashUpdated(address indexed user, string oldHash, string newHash);

    // Registra un nuovo hash con transazione classica
    //memory è una variabile temporanea della funzione
    //msg.sender rende univoco l'utente, è un indirizzo creato dalla propria chiave privata, firmando la richiesta ed
    //è possibile utilizzare quell'indirizzo solo una volta, grazie ad un nonce
    function register(string memory hash) public {
        require(bytes(userHashes[msg.sender]).length == 0, "Hash gia registrato");
        userHashes[msg.sender] = hash;
        emit HashRegistered(msg.sender, hash);
    }

    // Aggiorna l'hash dell'utente
    function updateHash(string memory newHash) public {
        require(bytes(userHashes[msg.sender]).length != 0, "Nessun hash registrato");
        string memory oldHash = userHashes[msg.sender];
        userHashes[msg.sender] = newHash;
        emit HashUpdated(msg.sender, oldHash, newHash);
    }

    // Visualizza l'hash dell'utente che chiama
    function getMyHash() public view returns (string memory) {
        return userHashes[msg.sender];
    }

    // Verifica se l'hash inserito corrisponde a quello salvato
    function verifyHash(string memory inputHash) public view returns (bool) {
        return keccak256(abi.encodePacked(userHashes[msg.sender])) == keccak256(abi.encodePacked(inputHash));
    }

    //Registra un hash con firma off-chain(firma generata fuori dalla blockchain)
    //Questo accade quando un utente non vuole inviare una transazione ma delega a qualcun'altro di farlo(mandandoli l'hash e la firma dell'hash
    //(la firma avviene off-chain cioè fuori dalla blockchain)) e quest'ultimo invia la transazione
    //L'utente non firma l'hash che vuole inserire, ma effettua prima un hash dell'hash e poi firma
    // in Solidity e in Ethereum le firme sono sempre fatte su bytes32
    // ecrecover(hash, v, r, s) accetta solo un bytes32 come primo parametro.
    //l'utente si limita a firmare il messaggio e qualcun'altro invia il messaggio allo smart contract, risparmio monetario

    //hash: è un hash che un utente vuole registrare
    //signature: è la firma dell'hash dell'hash perchè prima si effettua l'hash del messaggio(nel nostro caso un hash) e poi si firma
    function registerSigned(string memory hash, bytes memory signature) public {
        bytes32 messageHash = keccak256(abi.encodePacked(hash));
        //ricavo chi ha firmato
        address signer = recoverSigner(messageHash, signature);

    
        require(signer != address(0), "Firma non valida");
        require(bytes(userHashes[signer]).length == 0, "Hash gia registrato");

        userHashes[signer] = hash;
        emit HashRegistered(signer, hash);
    }

 
    // funzione per capire chi ha firmato
    function recoverSigner(bytes32 messageHash, bytes memory signature) public pure returns (address) {
        require(signature.length == 65, "Firma non valida");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        return ecrecover(messageHash, v, r, s);
    }
}

