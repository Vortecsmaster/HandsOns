{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE RecordWildCards       #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module GuessingGameV2 where

import qualified Data.ByteString.Char8 as C
import Ledger (Address, Datum (Datum), ScriptContext, Validator, Value, getCardanoTxId)
import qualified Ledger 
import qualified Ledger.Ada  as Ada
import qualified Ledger.Constraints  as Constraints
import Ledger.Tx (ChainIndexTxOut (..))
import qualified Plutus.Script.Utils.V2.Typed.Scripts as Scripts            -- New library name for Typed Validators and some new fuctions
import           Plutus.V2.Ledger.Contexts            as Contexts
import qualified Plutus.V2.Ledger.Api                 as PlutusV2   
import qualified PlutusTx 
import PlutusTx.Prelude hiding (pure, (<$>), Semigroup (..))




--ON-CHAIN

newtype HashedString = HS BuiltinByteString
   deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)

PlutusTx.makeLift ''HashedString

newtype ClearString = CS BuiltinByteString
    deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)

PlutusTx.makeLift ''ClearString

{-# INLINABLE validateGuess #-}
validateGuess :: HashedString -> ClearString -> PlutusV2.ScriptContext -> Bool
validateGuess hs cs _ = isGoodGuess hs cs
 
{-# INLINABLE isGoodGuess #-}
isGoodGuess :: HashedString -> ClearString -> Bool
isGoodGuess (HS secret) (CS guess') = secret == sha2_256 guess'

-- data Game
-- instance Scripts.ValidatorTypes Game where
--     type instance RedeemerType Game = ClearString
--     type instance DatumType Game = HashedString

-- gameInstance :: Scripts.TypedValidator Game
-- gameInstance = Scripts.mkTypedValidator @Game
--     $$(PlutusTx.compile [|| validateGuess ||])
--     $$(PlutusTx.compile [|| wrap ||]) where
--         wrap = Scripts.wrapValidator @HashedString @ClearString

-- gameValidator :: Validator
-- gameValidator = Scripts.validatorScript gameInstance

-- gameAddress :: Address
-- gameAddress = Ledger.scriptAddress gameValidator

hashString :: Haskell.String -> HashedString
hashString = HS . sha2_256 . toBuiltin . C.pack

clearString :: Haskell.String -> ClearString
clearString = CS . toBuiltin . C.pack
