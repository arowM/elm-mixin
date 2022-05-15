# elm-mixin

[![Build Status](https://api.travis-ci.com/arowM/elm-mixin.svg?branch=master)](https://app.travis-ci.com/github/arowM/elm-mixin)

Developer-friendly alternative to [`Html.Attribute`](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute), which can handle conditional attributes, [CSS custom properties](https://developer.mozilla.org/docs/Web/CSS/Using_CSS_custom_properties), and more.

## Example

```elm
import Html as RawHtml
import Mixin exposing (Html, Mixin)
import Mixin.Html as Html
import Mixin.Events as Events

...
...

formInput : Bool -> (String -> Msg) -> Mixin Msg
formInput isInvalid onInput =
    Mixin.batch
        [ Events.onInput onInput
        , Mixin.class "formInput"
        , Mixin.boolAttribute "aria-invalid" isInvalid
        ]


view : Model -> Html Msg
view model =
    Mixin.lift RawHtml.form
        [ Mixin.class "form"
        ]
        [ Html.div
            [ Mixin.class "form_row"
            ]
            [ Html.text "Name"
            , Mixin.lift RawHtml.input
                [ formInput (isInvalidName model) ChangeName
                , Mixin.class "formInput-name"
                , Mixin.style "--min-width" "10em"
                , if model.requireMiddleName then
                    Mixin.class "formInput-name-withMiddleName"
                  else
                    Mixin.none
                ]
                []
            ]
        , Html.div
            [ Mixin.class "form_row"
            ]
            [ Html.text "Age"
            , Mixin.lift RawHtml.input
                [ formInput (isInvalidAge model) ChangeAge
                , Mixin.class "formInput-age"
                , Mixin.style "--min-width" "6em"
                ]
                []
            ]
        ]
```
