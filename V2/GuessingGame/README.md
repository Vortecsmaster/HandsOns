# HandsOns
eMurgo Academy Hands on excercises

# TestNet Execution - Minting Policy Validator

Summary:
> This exercise is going to walkthrough in minting a NFT while using a minting policy validator on a testnet, by serializing the different requirements for the transaction construction and finally constructing and submitting your transaction for execution using Cardano-CLI.

## Part 1 Prepare the elements necessary Transaction construction 
What do we need?

* A working Plutus Developer Environment Nix-Shell
* A running node on the preview or preprod network.
* 1 paymentAddresses with some UTxO with ADA for providing Bounty Value.
* 1 paymentAddress with a UTxO with ADA **ONLY** for providing collateral. (Could be the same payment address)
* 1 paymentAddress for the receiving the minted value (could be the same payment address or different one).
* 1 addresss for recieving the change (could be one of the above or the same)
* Minting Validator Script (Serialized and JSON encoded)
* Redeemer (Serialized and JSON encoded)

## Part 2 Serializing and encoding 
###### STEP 1
Clone  the hands-ons repository

```bash
    git clone  https://github.com/Vortecsmaster/HandsOns.git
```
###### STEP 2

Run your NIX-SHELL in your plutus-app folder. Be sure that your plutus-apps is the tag/v1.0.0 branch.

###### STEP 3
In the your V2/NativeTokens folder execute 

```bash
    cabal repl
```

###### STEP 4
Modify the redeemer (type NFTParams)  with value for the TxOutRef (UTxO Transaction Hash and Index), line 61. This UTxO should be the same provided as input in the minting transaction (see step)

```haskell
    redeemer = NFTParams { mpAmount = 1,
               mpTxOutRef = PlutusV2.TxOutRef {txOutRefId = "<Put your UTxO TxId here!>"
             , txOutRefIdx = 0}                              
               }
```

###### STEP 5
On the REPL, Evaluate the functions on the NFTsV2 module (load it if its not loaded)

writeUnit
writeSerialisedScript

This is going to create the corresponding encoded/serialized files for unit (for the redeemer) and minting policy validator.

###### STEP 6
Build the policy.id file with the actual PolicyID (Hash derived from the minting policiy script)
```bash
    cardano-cli transaction policyid --script-file nftMintV2.plutus > policy.id
```

###### STEP 7 
In your testnet folder edit mintNFT.sh
```bash
    utxoin="<the same UTxO presented on the parameters of the minting policy validator in STEP 4"
    policyid=$(cat policy.id)
    address="<The payment address thats goint to recieve the NFT>"
    output="<amount of lovelaces sent to the output address, must cover the pegged ada value required for token"
    tokenamount="1"
    tokenname=$(echo -n "<Your NFT Name>" | xxd -ps | tr -d '\n')
    collateral="<The UTxO exposed as collateral>"
    signerPKH="<The pubkeyHash (verification keyHash from the paymentAddress providing the collateral)>"
```

```bash
cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
  --change-address <the address that is going to recieve the change> \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file nftMintV2.plutus \
  --mint-redeemer-file unit.json \
  --invalid-hereafter 3371469 \
  --protocol-params-file protocol.params \
  --out-file mintTx.body
```

```bash  
   cardano-cli transaction sign \
    --tx-body-file mintTx.body \
    --signing-key-file <signing key file, must include for every  signer> \
    $PREVIEW \
    --out-file mintTx.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file mintTx.signed
``` 

###### STEP 8
Execute ./mintNFT.sh

---
# CONGRATULATIONS: You just minted and NFT 

Now you can do the [Challenges](Challenges.md)