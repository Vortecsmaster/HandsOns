cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in 0ddb065817c1608e4577ed5ba71cbddc6fa84381410c74abd9e15c100a43af4f#0 \
  --tx-in-script-file ./mathBounty.plutus \
  --tx-in-datum-file ./datum.json \
  --tx-in-redeemer-file ./goodRedeemer.json \
  --required-signer-hash 4914ffe6af3b166cd8c3c5d085aba401f19264545dd8217a842c6562 \
  --tx-in-collateral f68ca74e325d9890476c956f0beb511066eb6dfce52c23a18d4979755fef493c#0 \
  --tx-out $(cat Wallet/Adr10.addr)+110000000 \
  --change-address $nami \
  --invalid-hereafter 4398094 \
  --protocol-params-file ./protocol.params \
  --out-file tx.body

cardano-cli transaction sign \
    --tx-body-file tx.body \
    --signing-key-file Wallet/Adr10.skey \
    $PREVIEW \
    --out-file tx.signed

cardano-cli transaction submit \
    $PREVIEW \
    --tx-file tx.signed