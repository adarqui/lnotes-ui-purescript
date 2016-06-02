module LN.View.Helpers (
  buttons_SaveEditCancel
) where



import Daimyo.Data.ArrayList           (listToArray)
import Data.Map                        as M
import Data.Maybe                      (Maybe(..), maybe)
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (id, map, ($), (<>))

import LN.Halogen.Util
import LN.Input.Types                  (Input(..))
import LN.Router.Link                  (linkToP_Classes, linkToP_Glyph', linkToP)
import LN.Router.Types                 (Routes(..), CRUD(..))
import LN.State.Loading                (getLoading, l_currentOrganization)
import LN.State.Types                  (State)
import LN.View.Module.Loading          (renderLoading)
import LN.View.Forums.Show             (renderView_Forums_Show)
import LN.T                            ( OrganizationPackResponse
                                       , _OrganizationPackResponse, _OrganizationResponse, organization_
                                       , _ForumPackResponse, _ForumResponse, forum_)



-- buttons_CreateSaveCancel :: Maybe Int -> Maybe Int -> (Int -> Input) -> (Int -> Input) -> Routes -> ComponentHTML Input
buttons_SaveEditCancel m_save_id save edit cancel =
  H.div_ [
    save_or_edit,
    simpleInfoButton "Cancel" (Goto cancel)
  ]
  where
  save_or_edit =
    case m_save_id of
         Nothing -> simpleInfoButton "Create" save
         Just id' -> simpleInfoButton "Save" (edit id')
