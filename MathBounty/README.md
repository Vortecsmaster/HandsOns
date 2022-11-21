# HandsOns
eMurgo Academy Live session excercises

# TestNet Execution - MathBouty contract

Summary:
> This exercise is going to walkthrough in executing a smart contract on a testnet, by serializing the different requirements for the transaction construction and finally constructing and submitting your transaction for execution using Cardano-CLI.

## Part 1 Prepare the elements necessary Transaction construction 
What do we need?

* A working Plutus Developer Environment Nix-Shell
* 1 paymentAddresses with some UTxO with ADA for providing Bounty Value.
* 1 paymentAddress with a UTxO with ADA **ONLY** for providing collateral. (Could be the same payment address)
* 1 paymentAddress for the counterpart that try to guess the solution and get the bounty.
* Validator Script (Serialized and JSON encoded)
* Datum (JSON encoded)
* Redeemer (JSON encoded)

## Part 2 Serializing and encoding 

###### STEP 1
    Clone or Pull the handsOn repository
    git clone  https://github.com/Vortecsmaster/HandsOns.git


###### STEP 2
    Run your NIX-SHELL

###### STEP 3
In the your GuessingGame folder execute 

    cabal repl

###### STEP 4
On the REPL, Evaluate the functions on the Deploy module (load it if its not loaded)

    writeUnit
    writeDatum
    writeRedeemer
    writeBadRedeemer
    writeBountyValidator

This is going to create the corresponding encoded/serialized files for unit, datum, goodRedeeer, badRedeemer and onChain validator.

###### STEP 5 
In your testnet folder edit theBlind.sh
```
    cardano-cli transaction build \
     --babbage-era \
     --testnet-magic 2 \
     --tx-in 5adfacd59c7d94d459d8d0117fc1d61e4aa7416df2641b3fc8bd9903a0c23275#0 \
     --tx-out $(cat guessingGame.addr)+50000000\
     --tx-out-datum-hash-file datum.json \
     --change-address $Adr01 \
     --out-file tx.unsigned
```

###### STEP 6
Execute the command
```  
     ./theBlind.sh
``` 

###### STEP 7
```
    cardano-cli transaction build \
     --babbage-era \
     $PREPROD \
     --tx-in 7e31cead428867928d256baf182499bb378907480c40d8425947867b77937334#1 \
     --tx-in-script-file ./guessingGame.plutus \
     --tx-in-datum-file ./datum.json \
     --tx-in-redeemer-file ./goodRedeemer.json \
     --required-signer-hash 697a501b7d05766b3d08e39dab43e0f170973d3398b28745b3b8ce55 \
     --tx-in-collateral 49842d4e339a80c58e0510d43226ce9bce213fee46d0e0135bbfe79afd391f4f#0 \
     --tx-out $Adr01+44000000 \
     --change-address $nami \
     --invalid-hereafter 13314102 \
     --protocol-params-file ./protocol.params \
     --out-file tx.body

    cardano-cli transaction sign \
     --tx-body-file tx.body \
     --signing-key-file ./Wallet/Adr07.skey \
     $PREPROD \
     --out-file tx.signed

    cardano-cli transaction submit \
     $PREPROD \
     --tx-file tx.signed
``` 

###### STEP 6
Execute the command
``` 
     ./theBlind.sh
```