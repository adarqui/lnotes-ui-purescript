module LN.View.Forums.RecentPosts (
  renderView_Forums_RecentPosts,
  renderView_Forums_RecentPosts'
) where



import LN.ArrayList                    (listToArray)
import Data.Map                        as M
import Data.Maybe                      (Maybe(..), maybe)
import Halogen                         (ComponentHTML, HTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (id, map, show, ($), (<>), (/=))

import LN.Input.Types                  (Input)
import LN.Router.Link                  (linkToP_Classes, linkToP_Glyph', linkToP)
import LN.Router.Types                 (Routes(..), CRUD(..))
import LN.Router.Class.Params          (emptyParams)
import LN.State.Types                  (State)
import LN.View.Helpers
import LN.View.Boards.Index            (renderView_Boards_Index')
import LN.View.Module.Loading          (renderLoading)
import LN.T




renderView_Forums_RecentPosts :: State -> ComponentHTML Input
renderView_Forums_RecentPosts st =

  case st.currentOrganization, st.currentForum of

       Just org_pack, Just forum_pack ->
         renderView_Forums_RecentPosts' org_pack forum_pack st.recentThreadPosts

       _, _                           -> renderLoading



--
-- Re: ADARQ's Journal by adarqui (Progress Journals & Experimental Routines) Today at 06:00:30 pm
--
renderView_Forums_RecentPosts'
  :: OrganizationPackResponse
  -> ForumPackResponse
  -> M.Map Int ThreadPostPackResponse
  -> ComponentHTML Input
renderView_Forums_RecentPosts' org_pack forum_pack posts_map =
  H.div [P.class_ B.containerFluid] [

    H.div [P.class_ B.pageHeader] [
      H.h4_ [H.text "Recent Posts"]
    ],


    H.ul [P.class_ B.listUnstyled] $
      map (\pack ->
        let
          post       = pack ^. _ThreadPostPackResponse .. threadPost_ ^. _ThreadPostResponse
        in
        H.li_ [
          H.p_ [H.text $ show post.id]
        ]
      ) $ listToArray $ M.values posts_map

  ]
  where
  org        = org_pack ^. _OrganizationPackResponse .. organization_ ^. _OrganizationResponse
  forum      = forum_pack ^. _ForumPackResponse .. forum_ ^. _ForumResponse