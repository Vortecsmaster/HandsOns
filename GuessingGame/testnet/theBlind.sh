cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in bc08bb8622908782484fbc99663af386f03c66c584d9e372c971a791bff0fa71#0 \
  --tx-out $(cat guessingGame.addr)+500000000\
  --tx-out-datum-hash-file datum.json \
  --change-address $Adr01 \
  --out-file tx.unsigned

cardano-cli transaction sign \
  --tx-body-file tx.unsigned \
  --signing-key-file ./Wallet/Adr01.skey \
  $PREVIEW \
  --out-file tx.signed

cardano-cli transaction submit \
  $PREVIEW \
  --tx-file tx.signed