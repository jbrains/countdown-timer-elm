module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Timer exposing (Timer)
import TypedTime exposing (TypedTime, minutes)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { timer : Timer, setTimeText : String, setTime : Result String TypedTime }


init : Model
init =
    { timer = Timer.activeTimerSetTo (minutes 10), setTimeText = "", setTime = Err "" }


type Msg
    = Tick
    | UpdateSetTimeText String
    | SetRemainingTime


parseTime : String -> Result String TypedTime
parseTime text =
    TypedTime.fromString TypedTime.Seconds text |> Result.fromMaybe text


formatTypedTimeResult : Result String TypedTime -> String
formatTypedTimeResult result =
    case result of
        Ok typedTime ->
            TypedTime.toString TypedTime.Seconds typedTime

        Err text ->
            text


update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick ->
            { model | timer = Timer.tick model.timer }

        UpdateSetTimeText newSetTimeText ->
            { model | setTimeText = newSetTimeText, setTime = parseTime newSetTimeText }

        SetRemainingTime ->
            case model.setTime of
                Ok newTime ->
                    { model | timer = Timer.activeTimerSetTo newTime }

                Err unparsableText ->
                    model


view : Model -> Html Msg
view { timer, setTimeText, setTime } =
    div []
        [ viewTimer timer setTimeText setTime ]


viewTimer : Timer -> String -> Result String TypedTime -> Html Msg
viewTimer timer setTimeText setTime =
    let
        markValid =
            Html.Attributes.style "border-color" ""

        markInvalid =
            Html.Attributes.style "border-color" "red"

        markInputFieldValidForResult result =
            case result of
                Ok _ ->
                    markValid

                Err _ ->
                    markInvalid
    in
    div []
        [ button [ onClick Tick ] [ text "tick" ]
        , input [ markInputFieldValidForResult setTime, placeholder "set time", value setTimeText, onInput UpdateSetTimeText ] []
        , label [] [ text (formatTypedTimeResult setTime) ]
        , button [ onClick SetRemainingTime ] [ text "set" ]
        , div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]
        ]
