module Mixin exposing
    ( Mixin
    , fromAttributes
    , toAttributes
    , batch
    , none
    , fromAttribute
    , attribute
    , class
    , id
    , when
    , unless
    , map
    )

{-| A brief module for Mixins.


# Core

@docs Mixin
@docs fromAttributes
@docs toAttributes
@docs batch
@docs none


# Attributes

@docs fromAttribute


## Common attributes

@docs attribute
@docs class
@docs id


## Conditional functions

@docs when
@docs unless


## Lower level functions

@docs map

-}

import Html exposing (Attribute)
import Html.Attributes as Attributes



-- Core


{-| Similar to `Html.Attribute msg` but more flexible and reusable.
-}
type Mixin msg
    = Mixin (List (Attribute msg))


{-| -}
map : (a -> b) -> Mixin a -> Mixin b
map f (Mixin attrs) =
    Mixin <| List.map (Attributes.map f) attrs


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



-- Conditional functions


{-| Insert a `Mixin` only when conditions are met.
-}
when : Bool -> Mixin msg -> Mixin msg
when p mixin =
    if p then
        mixin

    else
        none


{-| Insert a `Mixin` unless conditions are met.
-}
unless : Bool -> Mixin msg -> Mixin msg
unless p =
    when <| not p



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
