module Mixin exposing
    ( Mixin
    , fromAttributes
    , toAttributes
    , batch
    , none
    , lift
    , node
    , div
    , span
    , fromAttribute
    , attribute
    , class
    , id
    )

{-| A brief module for Mixins.


# Core

@docs Mixin
@docs fromAttributes
@docs toAttributes
@docs batch
@docs none


# Nodes

@docs lift


## Common nodes

@docs node
@docs div
@docs span


# Attributes

@docs fromAttribute


## Common attributes

@docs attribute
@docs class
@docs id

-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes



-- Core


{-| Similar to `Html.Attribute msg` but more flexible and reusable.
-}
type Mixin msg
    = Mixin (List (Attribute msg))


{-| -}
fromAttributes : List (Attribute msg) -> Mixin msg
fromAttributes =
    Mixin


{-| -}
toAttributes : Mixin msg -> List (Attribute msg)
toAttributes (Mixin attrs) =
    attrs


{-| -}
batch : List (Mixin msg) -> Mixin msg
batch ls =
    fromAttributes <| List.concatMap toAttributes ls


{-| -}
none : Mixin msg
none =
    Mixin []



-- Nodes


{-| Lift nodes to take `Mixin`s instead of `Attribute`s.

    import Html
    import Mixin

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
node : String -> List (Mixin msg) -> List (Html msg) -> Html msg
node name mixins =
    Html.node name <| List.concatMap toAttributes mixins


{-| -}
div : List (Mixin msg) -> List (Html msg) -> Html msg
div mixins =
    Html.div <| List.concatMap toAttributes mixins


{-| -}
span : List (Mixin msg) -> List (Html msg) -> Html msg
span mixins =
    Html.span <| List.concatMap toAttributes mixins



-- Attributes


{-| -}
fromAttribute : Attribute msg -> Mixin msg
fromAttribute attr =
    Mixin [ attr ]


{-| -}
attribute : String -> String -> Mixin msg
attribute name val =
    fromAttribute <|
        Attributes.attribute name val


{-| -}
class : String -> Mixin msg
class =
    fromAttribute << Attributes.class


{-| -}
id : String -> Mixin msg
id =
    fromAttribute << Attributes.id
