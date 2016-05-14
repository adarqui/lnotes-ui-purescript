module LN.View.Portal.Resources (
  renderView_Portal_Resources
) where



import Daimyo.Data.ArrayList           (listToArray)
import Data.Map                        as M
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (id, show, map, ($), (<>))

import LN.Input.Types                  (Input)
import LN.Router.Internal              (linkToP)
import LN.Router.Types                 (Routes(..), CRUD(..))
import LN.State.Types                  (State)
import LN.State.User                   (usersMapLookup_ToUser)
import LN.View.Module.Gravatar
import LN.View.Module.OrderBy
import LN.View.Module.PageNumbers
import LN.T



renderView_Portal_Resources :: State -> ComponentHTML Input
renderView_Portal_Resources st =
  H.div [P.class_ B.containerFluid] [
    H.div [P.class_ B.pageHeader] [
      H.h2_ [H.text "Resources"]
    ],
    H.div [P.class_ B.clearfix] [H.span [P.classes [B.pullLeft]] [renderOrderBy st.currentPage]],
    H.div [] [resources st]
  ]



resources :: State -> ComponentHTML Input
resources st =
  H.div_ [
    renderPageNumbers st.resourcesPageInfo st.currentPage
    , H.ul [P.class_ B.listUnstyled] $
        map (\(pack@(ResourcePackResponse resource_pack)) ->
          H.li_ [
            H.div [P.class_ B.row] [
                H.div [P.class_ B.colSm1] [
                  renderGravatarForUser Small (usersMapLookup_ToUser st (t pack ^. userId_))
                ]
              , H.div [P.class_ B.colSm6] [
--                    linkToP [] (OrganizationsForumsBoardsResources org_name forum_name board_name (Show $ t pack ^.  name_) []) (t pack ^. name_)
                    linkToP [] Home "home"
                  , H.p_ [H.text "page-numbers"]
                  , H.p_ [H.text $ show $ t pack ^. createdAt_]
                ]
              , H.div [P.class_ B.colSm1] [
                  H.p_ [H.text $ show (ts pack ^. leurons_) <> " leurons"]
                ]
              , H.div [P.class_ B.colSm1] [
                  H.p_ [H.text $ show (ts pack ^. views_) <> " views"]
                ]
              , H.div [P.class_ B.colSm3] [
                  H.div_ [ H.p_ [H.text "No Leurons."]]
              ]
            ]
          ])
        $ listToArray $ M.values st.resources
    , renderPageNumbers st.resourcesPageInfo st.currentPage
  ]
  where
  -- resource
  t x = (x ^. _ResourcePackResponse .. resource_ ^. _ResourceResponse)
  -- resource user
  tu x = (x ^. _ResourcePackResponse .. user_ ^. _UserSanitizedResponse)
  -- resource stat
  ts x = (x ^. _ResourcePackResponse .. stat_ ^. _ResourceStatResponse)
  -- resource post
--  tp x = (x ^. _ResourcePackResponse .. latestResource_)
  -- resource post user
--  tpu x = (x ^. _ResourcePackResponse .. latestResourceUser_)
