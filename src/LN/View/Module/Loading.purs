module LN.View.Module.Loading (
  renderLoading
) where



import Halogen                         (ComponentHTML)
import Halogen.HTML            as H
import Halogen.HTML.Properties as P
import Prelude                         (($))

import LN.Input.Types                  (Input)



renderLoading :: ComponentHTML Input
renderLoading =
  H.div_ [
    H.img [P.src "https://leuro.adarq.org/static/img/loading/2.gif"]
  ]
