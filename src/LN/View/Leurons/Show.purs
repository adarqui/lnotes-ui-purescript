module LN.View.Leurons.Show (
  renderView_Leurons_Show
) where



import Data.Maybe                      (Maybe(..))
import Halogen                         (ComponentHTML)
import Halogen.HTML.Indexed            as H
import Halogen.HTML.Properties.Indexed as P
import Halogen.Themes.Bootstrap3       as B
import Optic.Core                      ((^.), (..))
import Prelude                         (show, map, ($))

import LN.Input.Types                  (Input)
import LN.Router.Internal              (linkTo)
import LN.Router.Types                 (Routes(..), CRUD(..))
import LN.State.Types                  (State)
import LN.T



renderView_Leurons_Show :: String -> State -> ComponentHTML Input
renderView_Leurons_Show leuron_sid st =

  case st.currentLeuron of
       Nothing   -> H.div_ [H.text "Leuron Unavailable"]
       Just pack -> renderView_Leurons_Show' pack st



renderView_Leurons_Show' :: LeuronPackResponse -> State -> ComponentHTML Input
renderView_Leurons_Show' pack st =

  H.div [P.class_ B.containerFluid] [
    H.div [P.class_ B.pageHeader] [
      H.h1 [P.class_ B.textCenter] [H.text $ show leuron.id]
--      H.p [P.class_ B.textCenter] [H.text (leuron.description)]
    ],
    H.div [P.class_ B.container] [
      renderLeuron leuron'
    ]
  ]

 where
 leuron  = pack ^. _LeuronPackResponse .. leuron_ ^. _LeuronResponse
 leuron' = pack ^. _LeuronPackResponse .. leuron_



renderLeuron :: LeuronResponse -> ComponentHTML Input
renderLeuron leuron =
  H.div_ [
    renderLinks leuron',
    renderLeuronData leuron',
    renderLeuronSection leuron',
    renderLeuronExamples leuron',
    renderLeuronCategories leuron'
  ]
  where
  leuron' = leuron ^. _LeuronResponse



renderLinks :: LeuronResponseR -> ComponentHTML Input
renderLinks leuron =
  H.div_ [
    H.p_ [H.text "Resource: ", linkTo (Resources (Show $ show leuron.resourceId) []) (show leuron.resourceId)]
  ]



renderLeuronExamples :: LeuronResponseR -> ComponentHTML Input
renderLeuronExamples leuron =
  case leuron.examples of
    Nothing       -> H.div_ []
    Just examples ->
      H.div_ [
        H.p_ [
          H.h2_ [H.text "Examples"],
          H.ul_ $ map (\example -> H.li_ [H.pre_ [H.text example]]) examples
        ]
      ]



renderLeuronSection :: LeuronResponseR -> ComponentHTML Input
renderLeuronSection leuron =
  case leuron.section of
    Nothing      -> H.div_ []
    Just section ->
      H.div_ [
        H.p_ [
          H.h2_ [H.text "Section"],
          H.pre_ [H.text section]
        ]
      ]



renderLeuronCategories :: LeuronResponseR -> ComponentHTML Input
renderLeuronCategories leuron =
  case leuron.categories of
    [] -> H.div_ []
    _  ->
      H.div_ [
        H.p_ [
          H.h2_ [H.text "Categories"],
          H.ul_ $ map (\category -> H.li_ [H.pre_ [H.text $ show category]]) leuron.categories
        ]
      ]



renderLeuronData :: LeuronResponseR -> ComponentHTML Input
renderLeuronData leuron =
  case leuron.dataP of
    LnFact fact          -> renderLeuronData_Fact leuron (unwrapFact fact)
    LnFactList fact_list -> renderLeuronData_FactList leuron (unwrapFactList fact_list)
    LnCard card          -> renderLeuronData_Card leuron (unwrapCard card)
    LnDCard dcard        -> renderLeuronData_DCard leuron (unwrapDCard dcard)
    LnDCardX dcardx      -> renderLeuronData_DCardX leuron (unwrapDCardX dcardx)
    LnAcronym acronym    -> renderLeuronData_Acronym leuron (unwrapAcronym acronym)
    LnSynonym synonym    -> renderLeuronData_Synonym leuron (unwrapSynonym synonym)
    LnAntonym antonym    -> renderLeuronData_Antonym leuron (unwrapAntonym antonym)
    LnTemplate template  -> renderLeuronData_Template leuron (unwrapTemplate template)
    LnImageAssociation i -> renderLeuronData_ImageAssociation leuron (unwrapImageAssociation i)
    LnScript script      -> renderLeuronData_Script leuron (unwrapScript script)
    LnLinearDemo demo    -> renderLeuronData_LinearDemo leuron (unwrapLinearDemo demo)
    LnQA qa              -> renderLeuronData_QA leuron (unwrapQA qa)
    LnTable table        -> renderLeuronData_Table leuron (unwrapTable table)
    _                    -> renderLeuronData_Unknown leuron



renderLeuronData_Fact :: LeuronResponseR -> FactR -> ComponentHTML Input
renderLeuronData_Fact leuron fact =
  H.div_ [
    H.p_ [
      H.h2_ [H.text "Fact"],
      H.pre_ [H.text fact.text]
    ]
  ]




renderLeuronData_FactList :: LeuronResponseR -> FactListR -> ComponentHTML Input
renderLeuronData_FactList leuron fact_list =
  H.div_ [
    H.p_ [H.h2_ [H.text "Fact List"]],
    H.p_ [
      H.h2_ [H.text "Fact"],
      H.pre_ [H.text fact_list.fact]
    ],
    H.p_ [
      H.ul_ $ map (\fact -> H.li_ [H.pre_ [H.text fact]]) fact_list.list
    ]
  ]



renderLeuronData_Card :: LeuronResponseR -> CardR -> ComponentHTML Input
renderLeuronData_Card leuron card =
  H.div_ [
    H.p_ [H.h2_ [H.text "Card"]],
    H.p_ [H.h2_ [H.text "Front"], H.pre_ [H.text card.front]],
    H.p_ [H.h2_ [H.text "Back"], H.pre_ [H.text card.back]]
  ]



renderLeuronData_DCard :: LeuronResponseR -> DCardR -> ComponentHTML Input
renderLeuronData_DCard leuron dcard =
  H.div_ [
    H.p_ [H.h2_ [H.text "DCard"]],
    H.p_ [H.h2_ [H.text "Front"], H.pre_ [H.text dcard.front]],
    H.p_ [H.h2_ [H.text "Back"], H.pre_ [H.text dcard.back]]
  ]



renderLeuronData_DCardX :: LeuronResponseR -> DCardXR -> ComponentHTML Input
renderLeuronData_DCardX leuron dcardx =
  H.div_ [
    H.p_ [H.h2_ [H.text "DCardX"]],
    H.p_ [H.h2_ [H.text "Front"],
      H.ul_ $ map (\front -> H.li_ [H.pre_ [H.text front]]) dcardx.front
    ],
    H.p_ [H.h2_ [H.text "Back"],
      H.ul_ $ map (\back -> H.li_ [H.pre_ [H.text back]]) dcardx.back
    ]
  ]



renderLeuronData_Acronym :: LeuronResponseR -> AcronymR -> ComponentHTML Input
renderLeuronData_Acronym leuron acronym =
  H.div_ [
    H.p_ [H.h2_ [H.text "Acronym"]],
    H.p_ [H.h2_ [H.text "Abbrv"], H.pre_ [H.text acronym.abbreviation]],
    H.p_ [H.h2_ [H.text "Meaning"], H.pre_ [H.text acronym.meaning]]
  ]



renderLeuronData_Synonym :: LeuronResponseR -> SynonymR -> ComponentHTML Input
renderLeuronData_Synonym leuron synonym =
  H.div_ [
    H.p_ [H.h2_ [H.text "Synonym"]],
    H.p_ [H.h2_ [H.text "a"], H.pre_ [H.text synonym.a]],
    H.p_ [H.h2_ [H.text "b"], H.pre_ [H.text synonym.b]]
  ]



renderLeuronData_Antonym :: LeuronResponseR -> AntonymR -> ComponentHTML Input
renderLeuronData_Antonym leuron antonym =
  H.div_ [
    H.p_ [H.h2_ [H.text "Antonym"]],
    H.p_ [H.h2_ [H.text "a"], H.pre_ [H.text antonym.a]],
    H.p_ [H.h2_ [H.text "b"], H.pre_ [H.text antonym.b]]
  ]



renderLeuronData_Template :: LeuronResponseR -> TemplateR -> ComponentHTML Input
renderLeuronData_Template leuron template =
  H.div_ [H.p_ [H.text "template TODO"]]



renderLeuronData_ImageAssociation :: LeuronResponseR -> ImageAssociationR -> ComponentHTML Input
renderLeuronData_ImageAssociation leuron image_association =
  H.div_ [H.p_ [H.text "image_association TODO"]]



renderLeuronData_Script :: LeuronResponseR -> ScriptR -> ComponentHTML Input
renderLeuronData_Script leuron script =
  H.div_ [H.p_ [H.text "script TODO"]]



renderLeuronData_LinearDemo :: LeuronResponseR -> LinearDemoR -> ComponentHTML Input
renderLeuronData_LinearDemo leuron linear_demo =
  H.div_ [H.p_ [H.text "linear_demo TODO"]]



renderLeuronData_QA :: LeuronResponseR -> QAR -> ComponentHTML Input
renderLeuronData_QA leuron qa =
  H.div_ [H.p_ [H.text "qa TODO"]]



renderLeuronData_Table :: LeuronResponseR -> TableR -> ComponentHTML Input
renderLeuronData_Table leuron table =
  H.div_ [H.p_ [H.text "table TODO"]]



renderLeuronData_Unknown :: LeuronResponseR -> ComponentHTML Input
renderLeuronData_Unknown leuron =
  H.div_ [H.text "unknown"]
