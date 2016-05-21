module Vector2D exposing (Vector2D, vec, add, mul, sub, div, magnitude, normalize, limitMagnitude)


type alias Vector2D =
    { x : Float
    , y : Float
    }


vec : Float -> Float -> Vector2D
vec =
    Vector2D


add : Vector2D -> Vector2D -> Vector2D
add first second =
    Vector2D (first.x + second.x) (first.y + second.y)


mul : Float -> Vector2D -> Vector2D
mul scalar { x, y } =
    Vector2D (scalar * x) (scalar * y)


sub : Vector2D -> Vector2D -> Vector2D
sub first second =
    add first (mul -1 second)


div : Float -> Vector2D -> Vector2D
div scalar vector =
    mul (1 / scalar) vector


magnitude : Vector2D -> Float
magnitude { x, y } =
    sqrt ((x ^ 2) + (y ^ 2))


normalize : Vector2D -> Vector2D
normalize vector =
    if (magnitude vector) == 0 then
        vec 0 1
    else
        div (magnitude vector) vector


limitMagnitude : Float -> Vector2D -> Vector2D
limitMagnitude maximum_magnitude vector =
    let
        actual_magnitude =
            magnitude vector
    in
        if actual_magnitude < maximum_magnitude then
            vector
        else
            div (actual_magnitude / maximum_magnitude) vector
