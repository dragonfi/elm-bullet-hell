module Main exposing (..)

import Spec exposing (Spec, describe, it, shouldEqual)
import Spec.Runner.Console exposing (run)
import Html
import Vector2DSpec


testRunner : String
testRunner =
    run <| describe "All tests" [ Vector2DSpec.spec ]


main : Html.Html msg
main =
    Html.text testRunner
