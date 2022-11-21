cardano-cli transaction build \
  --babbage-era \
  $PREPROD \
  --tx-in eda61b395cd0d8cbe5d3ed2cd224b1eaac9951868be8b544b0e4facc985bbbfa#1 \
  --tx-in-script-file ./mathBounty.plutus \
  --tx-in-datum-file ./datum.json \
  --tx-in-redeemer-file ./goodRedeemer.json \
  --required-signer-hash 697a501b7d05766b3d08e39dab43e0f170973d3398b28745b3b8ce55 \
  --tx-in-collateral 49842d4e339a80c58e0510d43226ce9bce213fee46d0e0135bbfe79afd391f4f#0 \
  --tx-out $(cat Adr10.addr)+110000000 \
  --change-address $nami \
  --invalid-hereafter 13150906 \
  --protocol-params-file ./protocol.params \
  --out-file tx.body

cardano-cli transaction sign \
    --tx-body-file tx.body \
    --signing-key-file Adr07.skey \
    $PREPROD \
    --out-file tx.signed

cardano-cli transaction submit \
    $PREPROD \
    --tx-file tx.signed