module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Result.Extra
import Timer exposing (Timer)
import TypedTime exposing (TypedTime, minutes)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { timer : Timer, setTimeText : String, setTime : ParsedTime }


init : Model
init =
    { timer = Timer.activeTimerSetTo (minutes 10), setTimeText = "", setTime = Err "" }


type Msg
    = Tick
    | UpdateSetTimeText String
    | SetRemainingTime


type alias ParsedTime =
    Result String TypedTime


parseTime : String -> ParsedTime
parseTime text =
    TypedTime.fromString TypedTime.Seconds text |> Result.fromMaybe text


formatTypedTimeResult : ParsedTime -> String
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


viewTimer : Timer -> String -> ParsedTime -> Html Msg
viewTimer timer setTimeText setTime =
    div []
        [ button [ onClick Tick ] [ text "tick" ]
        , viewSetTimerControls setTimeText setTime
        , div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]
        ]


viewSetTimerControls : String -> ParsedTime -> Html Msg
viewSetTimerControls setTimeText setTime =
    let
        markValid _ =
            Html.Attributes.style "border-color" ""

        markInvalid _ =
            Html.Attributes.style "border-color" "red"

        highlightErrorsIn =
            Result.Extra.unpack markInvalid markValid
    in
    div []
        [ input [ highlightErrorsIn setTime, placeholder "set time", value setTimeText, onInput UpdateSetTimeText ] []
        , label [] [ text (formatTypedTimeResult setTime) ]
        , button [ onClick SetRemainingTime ] [ text "set" ]
        ]
