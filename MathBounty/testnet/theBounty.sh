cardano-cli transaction build \
  --babbage-era \
  $PREPROD \
  --tx-in 7ba89bcb9a5b1ed165dfeeef71b424561a5235d677940f9707ecccee73be41d1#0 \
  --tx-out $(cat mathBounty.addr)+500000000 \
  --tx-out-datum-hash-file datum.json \
  --change-address $(cat Adr10.addr) \
  --out-file tx.unsigned

cardano-cli transaction sign \
  --tx-body-file tx.unsigned \
  --signing-key-file Adr01.skey \
  $PREPROD \
  --out-file tx.signed

cardano-cli transaction submit \
  $PREPROD \
  --tx-file tx.signed