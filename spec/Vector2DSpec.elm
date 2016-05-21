module Vector2DSpec exposing (spec)

import Spec exposing (Spec, describe, it, shouldEqual)
import Vector2D exposing (Vector2D, vec, add, sub, div, mul, magnitude, normalize)


spec : Spec
spec =
    describe "Vector2D"
        [ it "can be added to another vector" [ shouldEqual (add (vec 1 2) (vec 3 4)) (vec 4 6) ]
        , it "can be subtracted from another vector" [ shouldEqual (sub (vec 1 2) (vec 3 5)) (vec -2 -3) ]
        , it "can be multiplied with a scalar" [ shouldEqual (mul 3 (vec 1 2)) (vec 3 6) ]
        , it "can be divided with a scalar" [ shouldEqual (div 3 (vec 9 3)) (vec 3 1) ]
        , it "has a magnitude" [ shouldEqual (magnitude (vec 3 4)) 5 ]
        , it "can be normalized"
            [ shouldEqual (normalize (vec 0 4)) (vec 0 1)
            , shouldEqual (normalize (vec 6 0)) (vec 1 0)
            ]
        ]
