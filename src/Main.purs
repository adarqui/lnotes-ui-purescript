module Main where



import Control.Coroutine as CR
import Control.Coroutine.Aff as CRA
import Control.Monad.Aff           (runAff, forkAff)
import Control.Monad.Aff.AVar      (makeVar, takeVar)
import Control.Monad.Eff           (Eff())
import Control.Monad.Eff.Exception (throwException)
import Control.Monad.Rec.Class     (forever)
import Data.Maybe                  (Maybe(..))
-- import Halogen                     (runUI, action)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
-- import Halogen.Util                (awaitLoad, awaitBody, selectElement)
import Prelude                     (Unit, unit, const, pure, bind, ($), (>>=))
import Partial.Unsafe
import Router                      as R

import LN.Component.Types          (LN)
import LN.Component                as Q
import LN.Input.Types              (Input(..))
import LN.State.Types              as S



main :: forall eff. Eff (LN eff) Unit
main = unsafePartial $ do

{-
  runAff throwException (const (pure unit)) do

    ch <- makeVar

    body   <- awaitBody
    m_node <- selectElement "#purescript-container"
    let node = (case m_node of
         Nothing   -> body
         Just node -> node)

    runUI Q.ui (S.initialState ch) body
-- TODO FIXME
    driver <- runUI Q.ui (S.initialState ch) body
    forkAff $ R.routeSignal driver
    driver (action GetMe)
    driver (action ConnectSocket)

    -- for web socket
    forever (takeVar ch >>= driver)
    pure unit
    -}


  HA.runHalogenAff do
    ch <- makeVar
    body <- HA.awaitBody
    io <- runUI (Q.ui (S.initialState ch)) unit body
    CR.runProcess (R.hashChangeProducer CR.$$ R.hashChangeConsumer io.query)

    io.query $ H.action GetMe
