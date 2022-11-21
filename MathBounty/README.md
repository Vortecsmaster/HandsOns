# HandsOns
eMurgo Academy Live session excercises


# TestNet Execution - MathBouty contract

Summary:
> This exercise is going to walkthrough in executing a smart contract on a testnet, by serializing the different requirements for the transaction construction and finally constructing and submitting your transaction for execution using Cardano-CLI.

## Part 1 Prepare the elements necessary Transaction construction 

What do we need?****

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
     --$PREPROD \
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

https://book.world.dev.cardano.org/environments.html#preview-testnet

alias preprodsp='export CARDANO_NODE_SOCKET_PATH="/home/plutus/cardano-src/db-preprod/node.socket"'
alias previewsp='export CARDANO_NODE_SOCKET_PATH="/home/plutus/cardano-src/db-preview/node.socket"'
alias legacysp='export CARDANO_NODE_SOCKET_PATH="/home/plutus/cardano-src/db-test/node.socket"'

export LEGACYSP="/home/plutus/cardano-src/db-test/node.socket"

export LEGACY="--testnet-magic 1097911063"
export PREPROD="--testnet-magic 1"
export PREVIEW="--testnet-magic 2"

export BINPATH="/home/plutus/.local/bin"
export SOURCES="/home/plutus/cardano-src"
export CONFIGPATH="$SOURCES/configuration"

export Adr01="addr_test1qz8a9te33ln0675t9atgvxmamgcjgyfgzcttjq5482lhzgwkx0qw82lv9jasu7cl0nggv5ps58rgg6mvt0t89fdsr82srsfq3f"
export Adr02="addr_test1qqwumapqc9yghg69wvx5rae2s3jz3w5pfs4avw2x96h45pemvtjg092unvw09zgm2az4evmg0anv5xgytk26jxaz2lussnpysf"
export Adr02b="addr_test1qpt0wtkcwjkczpan6wa5uluz8f742hv06xj0sdklr2tnv0355t7xvysfunn8p9azd7evxtmmx2tcy6w97nwgexr7f6hq9skq39"
export Adr03="addr_test1qrzsrvptgr2l4r0as5mm9xn4paxfw9lk3vtuu8rfjpefgsgswtez5z9lthxnps6pac4regy80vyu09g2lksqlvkwsw5suvngfy"
export Adr04="addr_test1qz90xdk4gl2z4vmtsdvqhzdqg76l9x59e3qu947nq0xvkw6z6dtpqss3ukpjw4d50d0w269nmunj8rtaqcsfgmdydvrqp2lfkp"
export Adr05="addr_test1qqd5ggrkuzhjty90wngxt5slk77apudj5ghukfr6c7hcpmde77zs55dum6e44eae80met2ugh4jy5an209v4ntjs6jjqpxs9uc"
export Adr06="addr_test1qrmgdc2amwd5edap39ht5g7glq7yyzst8nh7kdlnz8wdp3uegtqq39x00hsjd99qdacus2skvzsngyacpa6tqacn6q5styt4ep"
export Adr07="addr_test1qp5h55qm05zhv6eapr3em26rurchp9eaxwvt9p69kwuvu42rj9ynfzwggc0s55nlpqegv90w2rshnqf0q3um5pytk4qqutq8j6"
export nami="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt"

export nshell="./nshell.sh"
export ppp="cd /home/plutus/Dev/plutus-pioneer-program/code"

alias legacy-cli='$BINPATH/1.35.2/cardano-cli'


export PREPRODNODE="$BINPATH/cardano-node run --topology $CONFIGPATH/preprod/topology.json  --database-path $SOURCES/db-preprod --socket-path $SOURCES/db-preprod/node.socket --port 3001 --config $CONFIGPATH/preprod/config.json"
export PREVIEWNODE="$BINPATH/cardano-node run --topology $CONFIGPATH/preview/topology.json  --database-path $SOURCES/db-preview --socket-path $SOURCES/db-preview/node.socket --port 3001 --config $CONFIGPATH/preview/config.json"
export LEGACYNODE="$BINPATH/1.35.2/cardano-node run --topology $CONFIGPATH/cardano/testnet-topology.json  --database-path $SOURCES/db-test --socket-path $SOURCES/db-test/node.socket --port 3001 --config $CONFIGPATH/cardano/testnet-config.json"

alias ctip='cardano-cli query tip '
alias cutxo='cardano-cli query utxo --address '

export LD_LIBRARY_PATH=/usr/local/lib
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

