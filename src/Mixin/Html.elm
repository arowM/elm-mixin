module Mixin.Html exposing
    ( lift
    , div
    , span
    )

{-| Helper functions to do well with `Html`s.


# Core

@docs lift


## Common nodes

@docs div
@docs span

-}

import Html exposing (Attribute, Html)
import Mixin exposing (Mixin, toAttributes)



-- Core


{-| Lift nodes to take `Mixin`s instead of `Attribute`s.

    import Html
    import Mixin.Html as Mixin

    view : Html msg
    view =
        Mixin.lift Html.form
            [ Mixin.class "foo"
            ]
            []

-}
lift : (List (Attribute msg) -> List (Html msg) -> Html msg) -> List (Mixin msg) -> List (Html msg) -> Html msg
lift n mixins =
    n <| List.concatMap toAttributes mixins


{-| -}
div : List (Mixin msg) -> List (Html msg) -> Html msg
div mixins =
    Html.div <| List.concatMap toAttributes mixins


{-| -}
span : List (Mixin msg) -> List (Html msg) -> Html msg
span mixins =
    Html.span <| List.concatMap toAttributes mixins
