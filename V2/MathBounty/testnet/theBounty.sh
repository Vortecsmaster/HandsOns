cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in 012fd4ebd8743679974450823d32b2d6cf180aa8fdac5b80faa7f506ed5b53d4#0 \
  --tx-out $(cat mathBounty.addr)+40000000 \
  --tx-out-datum-hash-file datum.json \
  --change-address $(cat Wallet/Adr10.addr) \
  --out-file tx.unsigned

cardano-cli transaction sign \
  --tx-body-file tx.unsigned \
  --signing-key-file Wallet/Adr10.skey \
  $PREVIEW \
  --out-file tx.signed

cardano-cli transaction submit \
  $PREVIEW \
  --tx-file tx.signed