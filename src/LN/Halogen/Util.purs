module LN.Halogen.Util where

import Prelude

import Control.Alt ((<|>))
import Control.Monad.Aff (Aff(), runAff)
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (throwException)

import Data.Array
import Data.Either (Either(..))
import Data.Foldable (foldMap)
import Data.Functor (($>))
-- import Data.JSON (eitherDecode, decode, encode)
import Data.Maybe (Maybe(..), maybe, fromMaybe)
import Data.Tuple

import Halogen
import Halogen.HTML.Core as H
import Halogen.HTML as H
import Halogen.HTML.Events as E
import Halogen.HTML.Properties as PX
import Halogen.HTML.Properties as P

import Network.HTTP.Affjax (AJAX(), post, affjax, defaultRequest)
--import Network.HTTP.MimeType
--import Network.HTTP.MimeType.Common
import Network.HTTP.RequestHeader

import DOM.HTML.Location as DOM
import DOM.HTML.Window as DOM
import DOM.HTML as DOM

import Control.Monad.Eff
import Control.Monad.Eff.Class

import Control.Monad.Aff.Console (log)
import Control.Monad.Eff.Console (CONSOLE())


-- Buttons

buttonInfoClasses = buttonClasses "btn-info"
buttonDangerClasses = buttonClasses "btn-danger"

buttonClasses button_type = P.classes [ClassName "btn",  ClassName button_type]


-- Forms

formGroupClasses = P.classes [ClassName "form-group"]
formControlClasses = P.classes [ClassName "form-control"]


-- Radio

radioInlineClasses = P.classes [ClassName "radio-inline"]


-- Class Helpers
_class = P.class_ <<< ClassName
_classes classes = P.classes $ map ClassName classes




-- | Create a text field which can be edited or deleted
--
-- deleteAndEdit
--  P.InputText
--  author
--  (E.input (\new -> EditResourceAuthor author new))
--  (E.input_ (RemoveResourceAuthor author))

input_DeleteEdit input_type value edit_cb delete_cb =
  H.div
    [P.class_ (ClassName "input-group")]
    [
      H.input [formControlClasses, P.value value, E.onValueChange edit_cb, P.type_ input_type],
      H.span
        [P.class_ (ClassName "input-group-btn")]
        [
          H.button [
            buttonInfoClasses,
            P.title "Delete",
            E.onClick delete_cb
          ] [H.text "✖"]
        ]
    ]



input_DeleteEditLabel input_type label value edit_cb delete_cb =
  H.div
    [_class "form-group"]
    [
      H.label
        [_classes ["control-label col-sm-2"]]
        [H.text label]

    , H.div [_class "form-group"] [
        H.input [formControlClasses, _class "col-sm-6", P.value value, E.onValueChange edit_cb, P.type_ input_type],
          H.span
            [P.class_ (ClassName "input-group-btn")]
            [
              H.button [
                buttonDangerClasses,
                P.title "Delete",
                E.onClick delete_cb
              ] [H.text "✖"]
            ]
      ]
    ]



-- | Creates a mandatory field
--
-- labeledInputField "Title" "Title" resource.resourceTitle P.InputText (E.input SetResourcetitle)
--
input_Label label placeholder value input_type setter =
  H.div
    [formGroupClasses]
    [
      H.label_ [H.text label],
      H.input [
        formControlClasses,
        P.type_ input_type,
        P.placeholder placeholder,
        P.value value,
        E.onValueChange setter
      ]
    ]



-- | Creates a mandatory field
--
-- labeledTextAreaField "Title" "Title" resource.resourceTitle P.TextAreaText (E.input SetResourcetitle)
--
textArea_Label label placeholder value setter =
  H.div
    [formGroupClasses]
    [
      H.label_ [H.text label],
      H.textarea [
        formControlClasses,
        P.placeholder placeholder,
        P.value value,
        E.onValueChange setter
      ]
    ]



textArea_LabelWithButton label placeholder value button_name value_change_cb click_cb =
  H.div
    [P.class_ (ClassName "input-group")]
    [
      H.label_ [H.text label],
      H.textarea [formControlClasses, P.placeholder placeholder, P.value value, E.onValueChange value_change_cb],
      H.span
        [P.class_ (ClassName "input-group-btn")]
        [
          H.button [
            buttonInfoClasses,
            P.title button_name,
            E.onClick click_cb
          ] [H.text button_name]
        ]
    ]



textArea_DeleteEdit value edit_cb delete_cb =
  H.div
    [P.class_ (ClassName "input-group")]
    [
      H.textarea [formControlClasses, P.value value, E.onValueChange edit_cb],
      H.span
        [P.class_ (ClassName "input-group-btn")]
        [
          H.button [
            buttonInfoClasses,
            P.title "Delete",
            E.onClick delete_cb
          ] [H.text "✖"]
        ]
    ]



textArea_LabelWithButtons label placeholder value value_change_cb buttons =
  H.div
    [P.class_ (ClassName "input-group")]
    [
      H.textarea [formControlClasses, P.placeholder placeholder, P.value value, E.onValueChange value_change_cb],
      H.span
        [P.class_ (ClassName "input-group-btn")]
        [],
      H.p_ $ map (\(Tuple name cb) -> H.button [buttonInfoClasses, P.title name, E.onClick cb] [H.text name]) buttons
    ]



-- | Creates a mandatory field
--
-- labeledTextAreaField "Title" "Title" resource.resourceTitle P.TextAreaText (E.input SetResourcetitle)
--
textArea_Label_WithClear label placeholder value setter clear_cb =
  H.div
    [formGroupClasses]
    [
      H.label_ [H.text label],
      H.p_ [H.button
        [buttonInfoClasses, P.title "Clear", E.onClick clear_cb]
        [H.text "Clear"]],
      H.textarea [
        formControlClasses,
        P.placeholder placeholder,
        P.value value,
        E.onValueChange setter
      ]
    ]




-- | Creates a "maybe field".. ie, a field which has no value,
-- but has an "Add" button. The add button adds an input field.
-- Then, we can edit & delete it.
--
--
input_maybeField_DeleteEdit input_type label mvalue set_cb edit_cb delete_cb =
  H.div
    [formGroupClasses, _class "form-group"]
    [
      H.label [_classes ["control-label", "col-sm-2"]] [H. text label],
      case mvalue of
        Nothing ->
          H.button
            [buttonInfoClasses, P.title "Add", E.onClick set_cb]
            [H.text "Add"]
        (Just value) ->
          input_DeleteEdit input_type value edit_cb delete_cb
    ]



-- | Creates a radio menu
--
-- radioMenu "Leuron Type" "leuron-type" [NONE, FACT, CARD] SetLeuronType
--
radioMenu :: forall a b c d. Show c => Eq c => String -> String -> Array c -> (c -> Unit -> a Unit) -> c -> HTML b a
radioMenu menu_label radio_name radios setter checked_value =
  H.p_ $
      H.label_ [H.text menu_label] `cons`
      concatMap (\radio ->
          [H.label
            [radioInlineClasses]
            [H.text (show radio)]
           ,H.input [P.type_ P.InputRadio, P.name radio_name, P.value "", E.onChecked (E.input_ (setter radio)), P.checked (checked_value == radio)]
          ]
      ) radios



-- | Creates a multiple radio menu
--
-- multipleCheckboxMenu "Leuron Type" "leuron-type" [NONE, FACT, CARD] SetLeuronType
--
multipleCheckboxMenu :: forall a b c d. String -> String -> Array String -> (String -> Unit -> a Unit) -> Array Boolean -> HTML b a
multipleCheckboxMenu menu_label radio_name radios setter checked_values =
  H.p_ $
      H.label_ [H.text menu_label] `cons`
      (concatMap (\(Tuple radio checked_value) ->
          [H.label
            [radioInlineClasses]
            [H.text radio]
           ,H.input [P.type_ P.InputCheckbox, P.name radio_name, P.value "", E.onChecked (E.input_ (setter radio)), P.checked checked_value]
          ]
      ) $ zip radios checked_values)



-- | creates a simple info button
--
-- simpleInfoButton "Create!" CreateResource
--
simpleInfoButton label act = H.p_ [ H.button [buttonInfoClasses, E.onClick (E.input_ act) ] [ H.text label ] ]
