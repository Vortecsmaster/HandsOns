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