Titolo progetto
Password Registry Smart Contract

Descrizione sintetica
Il progetto consiste in uno smart contract scritto in Solidity che consente di associare un hash (ad esempio la rappresentazione di una password o di un documento) a un indirizzo Ethereum. Sono previste due modalità di registrazione:

Registrazione classica on‑chain tramite msg.sender

Registrazione tramite firma off‑chain verificata con ecrecover

Questa seconda modalità permette all’utente di firmare un messaggio in locale (es. via MetaMask) e delegare l’invio della transazione a un terzo, risparmiando sui costi di gas.

Scelte implementative

mapping(address => string) per associare hash a utenti.

Verifica dell’unicità della registrazione con require.

Funzioni di aggiornamento e verifica dell’hash.

Eventi per tracciare ogni operazione on‑chain.

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

Esempio di firma off‑chain via browser
const hash = "abc123";
const digest = web3.utils.soliditySha3(hash);
const accounts = await ethereum.request({ method: "eth_requestAccounts" });
const signature = await ethereum.request({
method: "personal_sign",
params: [digest, accounts[0]]
});
Chiamare quindi registerSigned("abc123", signature) su Remix.



Tecnologie utilizzate

Solidity ^0.8.0
Remix IDE
MetaMask
Ethereum (Sepolia Testnet)
ecrecover per verifica firme digitali