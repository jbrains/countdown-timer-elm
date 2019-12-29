module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Timer exposing (Timer)
import TypedTime exposing (minutes)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { timer : Timer, setTimeText : String }


init : Model
init =
    { timer = Timer.activeTimerSetTo (minutes 10), setTimeText = "" }


type Msg
    = Tick Timer
    | UpdateSetTimeText String
    | SetRemainingTime Timer String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick timer ->
            { model | timer = Timer.tick timer }

        UpdateSetTimeText text ->
            { model | setTimeText = text }

        SetRemainingTime timer newTimeAsText ->
            let
                maybeNewTime =
                    TypedTime.fromString TypedTime.Seconds newTimeAsText
            in
            case maybeNewTime of
                Just newTime ->
                    { model | timer = Timer.activeTimerSetTo newTime }

                Nothing ->
                    model


view : Model -> Html Msg
view { timer, setTimeText } =
    div []
        [ viewTimer timer setTimeText ]


viewTimer : Timer -> String -> Html Msg
viewTimer timer setTimeText =
    div []
        [ button [ onClick (Tick timer) ] [ text "tick" ]
        , input [ placeholder "Set time to", value setTimeText, onInput UpdateSetTimeText ] []
        , button [ onClick (SetRemainingTime timer setTimeText) ] [ text "set" ]
        , div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]
        ]
