module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Result.Extra
import Task
import Time
import Timer exposing (Timer(..))
import TypedTime exposing (TypedTime, minutes)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type TimerState
    = Running
    | Frozen


type alias Model =
    -- REFACTOR Move 'running' onto the Timer object in order to keep View Model and Domain Model separate.
    { timer : Timer, timeToSetAsText : String, running : Bool, timerState : TimerState }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        newModel =
            { timer = Timer.activeTimerSetTo (minutes 10), timeToSetAsText = "", running = False, timerState = Frozen }
    in
    ( newModel, Cmd.none )


type Msg
    = Tick
    | Start
    | Stop
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


timeToSet : Model -> ParsedTime
timeToSet model =
    model.timeToSetAsText |> parseTime


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            tickTimer model

        UpdateSetTimeText newSetTimeText ->
            updateSetTimeRemainingText model newSetTimeText

        SetRemainingTime ->
            setTimeRemaining model

        Start ->
            startTimer model

        Stop ->
            stopTimer model


tickTimer : Model -> ( Model, Cmd Msg )
tickTimer model =
    ( { model | timer = Timer.tick model.timer }, Cmd.none )


updateSetTimeRemainingText model newSetTimeText =
    ( { model | timeToSetAsText = newSetTimeText }, Cmd.none )


setTimeRemaining : Model -> ( Model, Cmd Msg )
setTimeRemaining model =
    case timeToSet model of
        Ok newTime ->
            ( { model | timer = Timer.activeTimerSetTo newTime }
            , Task.perform (always Stop) (Task.succeed 0)
            )

        Err unparsableText ->
            ( model, Cmd.none )


setTimerRunning model on =
    let
        newTimerState =
            if on then
                Running

            else
                Frozen

        newModel =
            case model.timer of
                ActiveTimer _ ->
                    { model
                        | running = on
                        , timerState = newTimerState
                    }

                ExpiredTimer ->
                    { model | running = False, timerState = Frozen }
    in
    ( newModel, Cmd.none )


startTimer model =
    setTimerRunning model True


stopTimer model =
    setTimerRunning model False


isTimerRunning model =
    model.running


subscriptions : Model -> Sub Msg
subscriptions model =
    if isTimerRunning model then
        Time.every 1000 (always Tick)

    else
        Sub.none


view : Model -> Html Msg
view { timer, timeToSetAsText } =
    let
        setTime =
            parseTime timeToSetAsText
    in
    div []
        [ viewTimer timer timeToSetAsText setTime ]


viewTimer : Timer -> String -> ParsedTime -> Html Msg
viewTimer timer timeToSetAsText setTime =
    div []
        [ div [] [ button [ onClick Tick ] [ text "tick" ] ]
        , div []
            [ button [ onClick Stop ] [ text "stop" ]
            , button [ onClick Start ] [ text "start" ]
            ]
        , viewSetTimerControls timeToSetAsText setTime
        , div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]
        ]


viewSetTimerControls : String -> ParsedTime -> Html Msg
viewSetTimerControls timeToSetAsText setTime =
    let
        -- REFACTOR Replace CSS style with CSS class
        markValid _ =
            Html.Attributes.style "border-color" ""

        markInvalid _ =
            Html.Attributes.style "border-color" "red"

        highlightErrorsIn =
            Result.Extra.unpack markInvalid markValid
    in
    div []
        [ input [ highlightErrorsIn setTime, placeholder "set time", value timeToSetAsText, onInput UpdateSetTimeText ] []
        , label [] [ text (formatTypedTimeResult setTime) ]
        , button [ onClick SetRemainingTime ] [ text "set" ]
        ]
