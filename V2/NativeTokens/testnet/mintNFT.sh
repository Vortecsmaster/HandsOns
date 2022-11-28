cardano-cli transaction build \
    --babbage-era \
    $PREPROD \
    --tx-in 83942cb31414d901dda39eea5509f36c7b1f68b034d5f75a2d810b7730abe21b#1 \
    --required-signer-hash 8fd2af318fe6fd7a8b2f56861b7dda312411281616b902953abf7121 \
    --tx-in-collateral 7e31cead428867928d256baf182499bb378907480c40d8425947867b77937334#0 \
    --tx-out $nami+
    --change-address $Adr01 \
    --mint "1 7eb3e40169a94722ba58dcb4ec45103b26c65c13b8c700d52d54bc2b.576f6e646572436f696e" \
    --mint-script-file nft-mint-V2.plutus \
    --mint-redeemer-file unit.json \
    --protocol-params-file protocol.params \
    --out-file tx.unsigned \


cardano-cli transaction sign \
    --tx-body-file tx.unsigned \
    --signing-key-file Wallet/Adr01.skey \
    $PREPROD \
    --out-file tx.signed

cardano-cli transaction submit \
    $PREPROD \
    --tx-file tx.signed