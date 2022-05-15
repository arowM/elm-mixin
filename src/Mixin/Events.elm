module Mixin.Events exposing
    ( onClick, onDoubleClick
    , onMouseDown, onMouseUp
    , onMouseEnter, onMouseLeave
    , onMouseOver, onMouseOut
    , onInput, onChange, onCheck, onSubmit
    , onBlur, onFocus
    , on, stopPropagationOn, preventDefaultOn, custom
    )

{-| [`Html.Events`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events) alternatives just for convenience.


# Mouse

@docs onClick, onDoubleClick
@docs onMouseDown, onMouseUp
@docs onMouseEnter, onMouseLeave
@docs onMouseOver, onMouseOut


# Forms

@docs onInput, onChange, onCheck, onSubmit


# Focus

@docs onBlur, onFocus


# Custom

@docs on, stopPropagationOn, preventDefaultOn, custom

-}

import Html.Events as Events
import Json.Decode as JD
import Mixin exposing (Mixin, fromAttributes)



-- MOUSE EVENTS


{-| -}
onClick : msg -> Mixin msg
onClick msg =
    fromAttributes [ Events.onClick msg ]


{-| -}
onDoubleClick : msg -> Mixin msg
onDoubleClick msg =
    fromAttributes [ Events.onDoubleClick msg ]


{-| -}
onMouseDown : msg -> Mixin msg
onMouseDown msg =
    fromAttributes [ Events.onMouseDown msg ]


{-| -}
onMouseUp : msg -> Mixin msg
onMouseUp msg =
    fromAttributes [ Events.onMouseUp msg ]


{-| -}
onMouseEnter : msg -> Mixin msg
onMouseEnter msg =
    fromAttributes [ Events.onMouseEnter msg ]


{-| -}
onMouseLeave : msg -> Mixin msg
onMouseLeave msg =
    fromAttributes [ Events.onMouseLeave msg ]


{-| -}
onMouseOver : msg -> Mixin msg
onMouseOver msg =
    fromAttributes [ Events.onMouseOver msg ]


{-| -}
onMouseOut : msg -> Mixin msg
onMouseOut msg =
    fromAttributes [ Events.onMouseOut msg ]



-- FORM EVENTS


{-| Alternetive to [`Html.Events.onInput`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput).
-}
onInput : (String -> msg) -> Mixin msg
onInput tagger =
    fromAttributes [ Events.onInput tagger ]


{-| Alternetive to [`Html.Events.Extra.onChange`](https://package.elm-lang.org/packages/elm-community/html-extra/latest/Html-Events-Extra#onChange).

Though `onChange` is not in `elm-html`, it makes it easy to debounce user input events for certain cases.

-}
onChange : (String -> msg) -> Mixin msg
onChange onChangeAction =
    on "change" <| JD.map onChangeAction Events.targetValue


{-| Alternetive to [`Html.Events.onCheck`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onCheck).
-}
onCheck : (Bool -> msg) -> Mixin msg
onCheck tagger =
    fromAttributes [ Events.onCheck tagger ]


{-| Alternetive to [`Html.Events.onSubmit`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onSubmit).
-}
onSubmit : msg -> Mixin msg
onSubmit msg =
    fromAttributes [ Events.onSubmit msg ]



-- FOCUS EVENTS


{-| -}
onBlur : msg -> Mixin msg
onBlur msg =
    fromAttributes [ Events.onBlur msg ]


{-| -}
onFocus : msg -> Mixin msg
onFocus msg =
    fromAttributes [ Events.onFocus msg ]



-- CUSTOM EVENTS


{-| Alternetive to [`Html.Events.on`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#on).
-}
on : String -> JD.Decoder msg -> Mixin msg
on event decoder =
    fromAttributes [ Events.on event decoder ]


{-| Alternetive to [`Html.Events.stopPropagationOn`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#stopPropagationOn).
-}
stopPropagationOn : String -> JD.Decoder ( msg, Bool ) -> Mixin msg
stopPropagationOn event decoder =
    fromAttributes [ Events.stopPropagationOn event decoder ]


{-| Alternetive to [`Html.Events.preventDefaultOn`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#preventDefaultOn).
-}
preventDefaultOn : String -> JD.Decoder ( msg, Bool ) -> Mixin msg
preventDefaultOn event decoder =
    fromAttributes [ Events.preventDefaultOn event decoder ]


{-| Alternetive to [`Html.Events.custom`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#custom).
-}
custom : String -> JD.Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool } -> Mixin msg
custom event decoder =
    fromAttributes [ Events.custom event decoder ]
