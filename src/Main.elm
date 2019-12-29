module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Timer exposing (Timer)
import TypedTime exposing (minutes)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { timer : Timer }


init : Model
init =
    { timer = Timer.activeTimerSetTo (minutes 10) }


type Msg
    = Tick


update : Msg -> Model -> Model
update msg { timer } =
    case msg of
        Tick ->
            { timer = Timer.tick timer }


view : Model -> Html Msg
view { timer } =
    div []
        [ viewTimer timer ]


viewTimer : Timer -> Html Msg
viewTimer timer =
    div []
        [ button [ onClick Tick ] [ text "tick" ]
        , div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]
        ]
