module Main exposing (..)

import Html
import Html.App
import Html.Attributes as HtmlA
import Html.Events
import Svg
import Svg.Attributes as SvgA
import Json.Decode
import Json.Decode exposing (Decoder, (:=))
import Time


type alias Position =
    { x : Int
    , y : Int
    }


type alias Model =
    { cursor_position : Position, mouse_clicks : Int, input : String }


type Message
    = Tick Time.Time
    | MouseMove Position
    | MouseClicked
    | Change String


subscriptions : Model -> Sub Message
subscriptions model =
    Time.every (50 * Time.millisecond) Tick


init : ( Model, Cmd msg )
init =
    ( Model (Position 0 0) 0 "", Cmd.none )


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MouseMove cursor_position ->
            ( { model | cursor_position = cursor_position }, Cmd.none )

        MouseClicked ->
            ( { model | mouse_clicks = model.mouse_clicks + 1 }, Cmd.none )

        Change x ->
            ( { model | input = x }, Cmd.none )

        _ ->
            ( model, Cmd.none )


type alias RawMouseMoveData =
    { clientX : Int
    , clientY : Int
    , offsetX : Int
    , offsetY : Int
    }


targetValue : Decoder Position
targetValue =
    Json.Decode.map translateCoordinates
        (Json.Decode.object4 RawMouseMoveData
            ("clientX" := Json.Decode.int)
            ("clientY" := Json.Decode.int)
            (Json.Decode.at [ "currentTarget", "offsetLeft" ] Json.Decode.int)
            (Json.Decode.at [ "currentTarget", "offsetTop" ] Json.Decode.int)
        )


translateCoordinates : RawMouseMoveData -> Position
translateCoordinates { clientX, clientY, offsetX, offsetY } =
    Position (clientX - offsetX) (clientY - offsetY)


onMouseMove : (Position -> msg) -> Html.Attribute msg
onMouseMove tag =
    Html.Events.on "mousemove" (Json.Decode.map tag targetValue)


view : Model -> Html.Html Message
view model =
    Html.div []
        [ Html.div [] [ Html.text "Non-capturing div" ]
        , Html.div
            [ Html.Events.onClick MouseClicked
            , onMouseMove MouseMove
            , HtmlA.style
                [ ( "background-color", "aliceblue" )
                , ( "width", "200px" )
                , ( "height", "200px" )
                ]
            ]
            [ Html.text <| toString model
            , Html.input [ Html.Events.onInput Change ] []
            ]
        , Html.div [ HtmlA.class "drawing-area", onMouseMove MouseMove ]
            [ Svg.svg
                [ SvgA.width "200px"
                , SvgA.height "200px"
                , SvgA.viewBox "0 0 200 200"
                ]
                [ Svg.rect
                    [ SvgA.x "0"
                    , SvgA.y "0"
                    , SvgA.width "200"
                    , SvgA.height "200"
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
            ]
        ]


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
