module Mixin exposing
    ( Mixin
    , fromAttributes
    , map
    , batch
    , none
    , style
    , property
    , attribute
    , class
    , id
    , boolAttribute
    , lift
    , when
    , unless
    , withMaybe
    )

{-| Core module for elm-mixin, which makes it easy to handle conditional attributes, [CSS custom properties](https://developer.mozilla.org/docs/Web/CSS/Using_CSS_custom_properties), and more.


# Primitives

@docs Mixin
@docs fromAttributes
@docs map
@docs batch
@docs none
@docs style
@docs property
@docs attribute


# Super Common Attributes

@docs class
@docs id
@docs boolAttribute


# Apply on HTML Nodes

@docs lift


# Conditional Functions

@docs when
@docs unless
@docs withMaybe

-}

import Html exposing (Attribute)
import Html.Attributes as Attributes
import Json.Encode exposing (Value)



-- Core


{-| Developer-friendly alternative to `Html.Attribute msg`.
-}
type Mixin msg
    = Mixin (Mixin_ msg)


type alias Mixin_ msg =
    { attributes : List (Attribute msg)
    , styles : List ( String, String )
    }


toAttributes : Mixin msg -> List (Attribute msg)
toAttributes (Mixin mixin) =
    mixin.styles
        |> List.foldl
            (\( k, v ) acc ->
                acc ++ k ++ ":" ++ v ++ ";"
            )
            ""
        |> Attributes.attribute "style"
        |> (\a -> a :: mixin.attributes)


{-| -}
map : (a -> b) -> Mixin a -> Mixin b
map f (Mixin mixin) =
    Mixin
        { attributes = List.map (Attributes.map f) mixin.attributes
        , styles = mixin.styles
        }


mempty : Mixin a
mempty =
    Mixin
        { attributes = []
        , styles = []
        }


{-| No HTML attributes.
-}
none : Mixin msg
none =
    Mixin
        { attributes = []
        , styles = []
        }


{-| When you need to set a couple HTML attributes only if a certain condition is met, you can batch them together.

    greeting : Animal -> Html msg
    greeting animal =
        Mixin.div
            [ Mixin.class "greeting"
            , case animal of
                Goat { horns } ->
                    Mixin.batch
                        [ Mixin.class "greeting-goat"
                        , Mixin.style "--horns" (String.fromInt horns)
                        ]

                Dog ->
                    Mixin.batch
                        [ Mixin.class "greeting-dog"
                        ]

                _ ->
                    Mixin.none
            ]
            [ text "Hello!"
            ]

Note1: `Mixin.none` and `Mixin.batch [ Mixin.none, Mixin.none ]` and `Mixin.batch []` all do the same thing.

Note2: It simply flattens as each item appears; so `[ Mixin.batch [ foo, bar ], baz, Mixin.batch [ foobar, foobaz ] ]` is reduced to `[ foo, bar, baz, foobar, foobaz ]`.

-}
batch : List (Mixin msg) -> Mixin msg
batch =
    List.foldl
        (\(Mixin a) (Mixin acc) ->
            Mixin
                { attributes = a.attributes ++ acc.attributes
                , styles = a.styles ++ acc.styles
                }
        )
        mempty


{-| Specify a style.

    greeting : Html msg
    greeting =
        Mixin.div
            [ Mixin.style "background-color" "red"
            , Mixin.style "height" "90px"
            , Mixin.style "--min-height" "3em"
            , Mixin.style "width" "100%"
            ]
            [ text "Hello!"
            ]

Unlike [`Html.Attributes.style`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style), this `style` can also handle [CSS custom properties](https://developer.mozilla.org/docs/Web/CSS/Using_CSS_custom_properties) well.

-}
style : String -> String -> Mixin msg
style key val =
    Mixin
        { styles = [ ( key, val ) ]
        , attributes = []
        }


{-| Lower level function to build `Mixin` from [`Html.Attribute`](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute)s.

    onClick : msg -> Mixin msg
    onClick msg =
        Mixin.fromAttributes
            [ Html.Events.onClick msg
            ]

-}
fromAttributes : List (Attribute msg) -> Mixin msg
fromAttributes ls =
    Mixin
        { styles = []
        , attributes = ls
        }


{-| Alternative to [`Html.Attributes.property`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#property).

    import Json.Encode as Encode

    class : String -> Mixin msg
    class name =
        Mixin.property "className" (Encode.string name)

-}
property : String -> Value -> Mixin msg
property k v =
    fromAttributes [ Attributes.property k v ]


{-| Alternative to [`Html.Attributes.attribute`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#attribute).

    class : String -> Mixin msg
    class name =
        Mixin.attribute "class" name

-}
attribute : String -> String -> Mixin msg
attribute k v =
    fromAttributes [ Attributes.attribute k v ]



-- Super Common Attributes


{-| Alternative to [`Html.Attributes.class`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#class).
-}
class : String -> Mixin msg
class name =
    fromAttributes [ Attributes.class name ]


{-| Alternative to [`Html.Attributes.id`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#id).
-}
id : String -> Mixin msg
id name =
    fromAttributes [ Attributes.id name ]


{-| Create arbitrary bool `attribute`.
The `boolAttribute` converts the `Bool` argument into the string `"true"` or `"false"`.

    ariaHidden : Bool -> Mixin msg
    ariaHidden =
        boolAttribute "aria-hidden"

-}
boolAttribute : String -> Bool -> Mixin msg
boolAttribute name p =
    attribute name <|
        if p then
            "true"

        else
            "false"



-- Apply on HTML Nodes


{-| Apply `Mixin` on `Html` functions.

    view : Html msg
    view =
        Mixin.lift Html.div
            [ Mixin.class "foo"
            , Mixin.id "bar"
            ]
            [ Html.text "baz"
            ]

-}
lift : (List (Attribute msg) -> a) -> List (Mixin msg) -> a
lift f mixins =
    batch mixins
        |> toAttributes
        |> f



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


{-| Insert a `Mixin` only when the value actually exists.
-}
withMaybe : Maybe a -> (a -> Mixin msg) -> Mixin msg
withMaybe ma f =
    case ma of
        Nothing ->
            none

        Just a ->
            f a
