# elm-mixin

[![Build Status](https://travis-ci.org/arowM/elm-mixin.svg?branch=master)](https://travis-ci.org/arowM/elm-mixin)

A brief Elm library for Mixins. The mixins are more flexible and reusable than `Html.Attribute msg`.

## Example

```elm
import Html exposing (Html)
import Html.Events as Events
import Mixin exposing (Mixin)

...
...

formInput : Bool -> (String -> Msg) -> Mixin Msg
formInput isInvalid onInput =
    Mixin.batch
        [ Mixin.fromAttribute <| Events.onInput onInput
        , Mixin.class "formInput"
        , Mixin.attribute "aria-invalid" <|
            if isInvalid then
                "true"
            else
                "false"
        ]


view : Model -> Html Msg
view model =
    Mixin.lift Html.form
        [ Mixin.class "form"
        ]
        [ Mixin.div
            [ Mixin.class "form_row"
            ]
            [ Html.text "Name"
            , Mixin.lift Html.input
                [ formInput (isInvalidName model) ChangeName
                , Mixin.class "formInput-name"
                ]
                []
            ]
        , Mixin.div
            [ Mixin.class "form_row"
            ]
            [ Html.text "Age"
            , Mixin.lift Html.input
                [ formInput (isInvalidAge model) ChangeAge
                , Mixin.class "formInput-age"
                ]
                []
            ]
        ]
```
