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


type alias Position =
    { x : Int
    , y : Int
    }


type alias Model =
    { cursor_position : Position, mouse_clicks : Int, input : String, window_size : Window.Size }


type Message
    = Tick Time.Time
    | MouseMove Position
    | WindowResize Window.Size
    | MouseClicked
    | Change String
    | Error String


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Time.every (50 * Time.millisecond) Tick
        , Mouse.moves MouseMove
        , Window.resizes WindowResize
        ]


init : ( Model, Cmd Message )
init =
    ( Model (Position 0 0) 0 "" (Window.Size 0 0), Task.perform Error WindowResize Window.size )


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MouseMove cursor_position ->
            ( { model | cursor_position = cursor_position }, Cmd.none )

        MouseClicked ->
            ( { model | mouse_clicks = model.mouse_clicks + 1 }, Cmd.none )

        Change x ->
            ( { model | input = x }, Cmd.none )

        WindowResize size ->
            ( { model | window_size = size }, Cmd.none )

        _ ->
            ( model, Cmd.none )


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
                [ SvgA.cx <| toString model.cursor_position.x
                , SvgA.cy <| toString model.cursor_position.y
                , SvgA.r "40"
                , SvgA.fill "#00cccc"
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
