Primo Test Smart Contract

Password Registry Smart Contract

Il progetto consiste in uno smart contract scritto in Solidity che consente di associare un hash (ad esempio la rappresentazione di una password o di un documento) a un indirizzo Ethereum. Sono previste due modalità di registrazione:

Registrazione classica on‑chain tramite msg.sender

Registrazione tramite firma off‑chain verificata con ecrecover

Questa seconda modalità permette all’utente di firmare un messaggio in locale (es. via MetaMask) e delegare l’invio della transazione a un terzo, risparmiando sui costi di gas.


Funzione registerSigned per supportare firme off‑chain:
• keccak256 per generare il messaggio da firmare.
• ecrecover per recuperare l’indirizzo del firmatario.
• Se la firma è valida e l’indirizzo non ha già un hash registrato, l’associazione viene salvata.

Procedura di test

Caricare passwordRegistryEcrecover.sol su Remix.

Compilare 

Selezionare Injected Provider – MetaMask.

Deploy del contratto sulla rete di test Sepolia.

Utilizzare le funzioni register, updateHash, getMyHash, verifyHash, registerSigned.
Per testare registerSigned bisogna avviare un server(python3 -m http.server 8000) aprirci su firmahash.html.
A questo punto, inserendo un hash, si ricava una firma. Essa dipende dall'account di Metamask selezionato.
Ora inserire l'hash e la firma nella funzione registerSigned e se l'account Metamask connesso su Remix e lo stesso di quello che 
ha generato la firma allora basterà eseguire un getMyHash per verifica la correttezza delle operazioni, altrimenti bisognerà
utilizzare la funzione getHashOf inserendo come parametro l'identificativo dell'utente che ha firmato l'hash.

Grazie a registerSigned è possibile delegare una transazione ad un altro utente e comunque l'hash verrà salvato all'utente corretto
recuperando le informazioni dalla firma.
