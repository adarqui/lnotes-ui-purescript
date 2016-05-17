module LN.Eval.Forums (
  eval_GetForums,
  eval_GetForumsForOrg
) where



import Control.Monad.Aff.Console       (log)
import Data.Either                     (Either(..))
import Data.Functor                    (($>))
import Halogen                         (modify, liftAff')
import Prelude                         (bind, pure, show, ($), (<>))

import LN.Api                          (rd, getForums', getForums_ByOrganizationName')
import LN.Component.Types              (EvalEff)
import LN.Input.Types                  (Input(..))
import LN.T



eval_GetForums :: EvalEff
eval_GetForums eval (GetForums next) = do

  pure next

{- TODO FIXME: do we use this?
  eforums <- rd $ getForums'
  case eforums of
    Left err -> pure next
    Right (ForumResponses forums) -> do
      modify (_{ forums = forums.forumResponses })
      pure next
      -}



eval_GetForumsForOrg :: EvalEff
eval_GetForumsForOrg eval (GetForumsForOrg org_name next) = do

  eforums <- rd $ getForums_ByOrganizationName' org_name
  case eforums of
    Left err -> liftAff' $ log ("getForums_ByOrgName: Error: " <> show err) $> next
    Right (ForumResponses forums) -> do
      modify (_{ forums = forums.forumResponses })
      pure next
