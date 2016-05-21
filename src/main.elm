module Main exposing (..)

import Html
import Html.App
import Html.Attributes as HtmlA
import Svg
import Svg.Attributes as SvgA
import Time
import Platform.Sub as Sub
import Mouse
import Window
import Task
import Vector2D


type alias MousePosition =
    { x : Int
    , y : Int
    }


type alias Player =
    { position : Vector2D.Vector2D
    , max_speed : Float
    }


type alias Bullet =
    { position : Vector2D.Vector2D
    , speed : Float
    }


type alias Model =
    { cursor_position : Vector2D.Vector2D
    , player : Player
    , mouse_clicks : Int
    , window_size : Window.Size
    , bullets : List Bullet
    }


type Message
    = Tick Time.Time
    | MouseMove MousePosition
    | WindowResize Window.Size
    | MouseClicked
    | Change String
    | Error String


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Time.every (10 * Time.millisecond) Tick
        , Mouse.moves MouseMove
        , Window.resizes WindowResize
        ]


init : ( Model, Cmd Message )
init =
    ( { cursor_position = (Vector2D.Vector2D 0 0)
      , player = Player (Vector2D.Vector2D 0 0) 4
      , mouse_clicks = 0
      , window_size = Window.Size 0 0
      , bullets = []
      }
    , Task.perform Error WindowResize Window.size
    )


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MouseMove { x, y } ->
            ( { model | cursor_position = Vector2D.Vector2D (toFloat x) (toFloat y) }, Cmd.none )

        MouseClicked ->
            ( { model | mouse_clicks = model.mouse_clicks + 1 }, Cmd.none )

        WindowResize size ->
            ( { model | window_size = size }, Cmd.none )

        Tick time ->
            ( { model
                | player = updatePlayer time model.cursor_position model.player
                , bullets = List.map (updateBullet time model.player.position) model.bullets
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


updatePlayer : Time.Time -> Vector2D.Vector2D -> Player -> Player
updatePlayer time cursor_position player =
    let
        cursor_delta =
            Vector2D.sub cursor_position player.position |> Vector2D.limitMagnitude player.max_speed
    in
        { player
            | position = Vector2D.add player.position cursor_delta
        }


updateBullet : Time.Time -> Vector2D.Vector2D -> Bullet -> Bullet
updateBullet time player_position bullet =
    bullet


view : Model -> Html.Html Message
view model =
    Html.div []
        [ Svg.svg
            [ SvgA.width <| toString model.window_size.width
            , SvgA.height <| toString model.window_size.height
            , SvgA.viewBox
                <| "0 0 "
                ++ (toString model.window_size.width)
                ++ " "
                ++ (toString model.window_size.height)
            ]
            [ Svg.rect
                [ SvgA.x "0"
                , SvgA.y "0"
                , SvgA.width <| toString model.window_size.width
                , SvgA.height <| toString model.window_size.height
                , SvgA.fill "#00aaaa"
                ]
                []
            , Svg.circle
                [ SvgA.cx <| toString model.player.position.x
                , SvgA.cy <| toString model.player.position.y
                , SvgA.r "40"
                , SvgA.fill "#00cccc"
                ]
                []
            , Svg.circle
                [ SvgA.cx <| toString model.cursor_position.x
                , SvgA.cy <| toString model.cursor_position.y
                , SvgA.r "10"
                , SvgA.fill "#00ffff"
                ]
                []
            ]
        , Html.div
            [ HtmlA.style
                [ ( "position", "absolute" )
                , ( "top", "1em" )
                , ( "left", "1em" )
                ]
            ]
            [ Html.text <| toString model ]
        ]


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
