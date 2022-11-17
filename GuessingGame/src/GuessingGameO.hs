{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE DeriveAnyClass      #-}
{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE NoImplicitPrelude   #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}
{-# LANGUAGE DerivingStrategies  #-}
{-# LANGUAGE ImportQualifiedPost  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving  #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module GuessingGameO where

import Control.Monad (void)
import Data.ByteString.Char8 qualified as C
import Data.Text                  (Text)
import Data.Void
import Data.Map (Map)
import Data.Map qualified as Map
import Data.Maybe (catMaybes)
import Ledger (Address, Datum (Datum), ScriptContext, Validator, Value, getCardanoTxId)
import Ledger qualified
import Ledger.Ada qualified as Ada
import Ledger.Constraints qualified as Constraints
import Ledger.Tx (ChainIndexTxOut (..))
import Ledger.Typed.Scripts qualified as Scripts
import Playground.Contract
import Plutus.Contract
import PlutusTx qualified
import PlutusTx.Prelude hiding (pure, (<$>), Semigroup (..))
import Prelude (Semigroup (..))
import Prelude qualified as Haskell
import           Text.Printf          (printf)
import qualified Plutus.Trace              as Trace
import           Plutus.Trace.Emulator     as Emulator
import           Wallet.Emulator.Wallet

--ON-CHAIN

newtype HashedString = HS BuiltinByteString
   deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)

PlutusTx.makeLift ''HashedString

newtype ClearString = CS BuiltinByteString
    deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)

PlutusTx.makeLift ''ClearString

data Game
instance Scripts.ValidatorTypes Game where
    type instance RedeemerType Game = ClearString
    type instance DatumType Game = HashedString

{-# INLINABLE validateGuess #-}
validateGuess :: HashedString -> ClearString -> ScriptContext -> Bool
validateGuess hs cs _ = isGoodGuess hs cs
 
{-# INLINABLE isGoodGuess #-}
isGoodGuess :: HashedString -> ClearString -> Bool
isGoodGuess (HS secret) (CS guess') = secret == sha2_256 guess'

gameInstance :: Scripts.TypedValidator Game
gameInstance = Scripts.mkTypedValidator @Game
    $$(PlutusTx.compile [|| validateGuess ||])
    $$(PlutusTx.compile [|| wrap ||]) where
        wrap = Scripts.wrapValidator @HashedString @ClearString

gameValidator :: Validator
gameValidator = Scripts.validatorScript gameInstance

gameAddress :: Address
gameAddress = Ledger.scriptAddress gameValidator

hashString :: Haskell.String -> HashedString
hashString = HS . sha2_256 . toBuiltin . C.pack

clearString :: Haskell.String -> ClearString
clearString = CS . toBuiltin . C.pack
