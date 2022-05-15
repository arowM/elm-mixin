module Mixin.Html exposing
    ( Html
    , Attribute
    , text
    , node
    , keyed
    , div
    , span
    , p
    , a
    )

{-| [`Html`](https://package.elm-lang.org/packages/elm/html/latest/Html) alternatives just for convenience.


# Primitives

@docs Html
@docs Attribute
@docs text
@docs node
@docs keyed


## Super Common Tags

@docs div
@docs span
@docs p
@docs a

-}

import Html
import Html.Keyed
import Mixin exposing (Mixin, lift)



-- Primitives


{-| Reexport [`Html.Html`](https://package.elm-lang.org/packages/elm/html/latest/Html#Html) just for convenience.
-}
type alias Html msg =
    Html.Html msg


{-| Reexport [`Html.Attribute`](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute) just for convenience.
-}
type alias Attribute msg =
    Html.Attribute msg


{-| Reexport [`Html.text`](https://package.elm-lang.org/packages/elm/html/latest/Html#text) just for convenience.
-}
text : String -> Html msg
text =
    Html.text


{-| Alternative to [`Html.node`](https://package.elm-lang.org/packages/elm/html/latest/Html#node). It is a handy way to create HTML nodes with `Mixin`.

    div : List (Mixin msg) -> List (Html msg) -> Html msg
    div mixins children =
        Mixin.node "div" mixins children

-}
node : String -> List (Mixin msg) -> List (Html msg) -> Html msg
node name =
    lift (Html.node name)


{-| Works just like `node`, but you add a unique identifier to each child node. See [`Html.Keyed.node`](https://package.elm-lang.org/packages/elm/html/latest/Html-Keyed#node) for details.
-}
keyed :
    String
    -> List (Mixin msg)
    -> List ( String, Html msg )
    -> Html msg
keyed name =
    lift (Html.Keyed.node name)


{-| Represents a generic container with no special meaning.

See [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div) for details.

-}
div : List (Mixin msg) -> List (Html msg) -> Html msg
div =
    lift Html.div


{-| Represents text with no specific meaning.

See [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span) for details.

-}
span : List (Mixin msg) -> List (Html msg) -> Html msg
span =
    lift Html.span


{-| Defines a portion that should be displayed as a paragraph.

See [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p) for details.

-}
p : List (Mixin msg) -> List (Html msg) -> Html msg
p =
    lift Html.p


{-| Represents a hyperlink, linking to another resource.

See [MDN document](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a) for details.

-}
a : List (Mixin msg) -> List (Html msg) -> Html msg
a =
    lift Html.a
