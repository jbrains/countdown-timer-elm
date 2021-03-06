port module Main exposing (..)

import Browser
import Html exposing (Html, audio, button, div, input, label, text)
import Html.Attributes exposing (controls, id, placeholder, src, value)
import Html.Events exposing (onClick, onInput)
import Result.Extra
import Task
import Time
import Timer exposing (Timer(..), TimerEvent(..))
import TypedTime exposing (TypedTime, minutes)


port expired : () -> Cmd unusedType


port warning : () -> Cmd unusedType


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type alias Model =
    -- REFACTOR Better isolate Domain Model from View Model
    { timer : Timer, timeToSetAsText : String }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        initTimer =
            10 |> minutes |> Timer.stoppedAtTime

        newModel =
            { timer = initTimer, timeToSetAsText = "" }
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
            let
                tickResult =
                    Timer.tick model.timer
            in
            case tickResult of
                ( timer, Expired ) ->
                    ( { model | timer = timer }, expired () )

                ( timer, Warning ) ->
                    ( { model | timer = timer }
                    , warning ()
                    )

                ( timer, Timer.Nothing ) ->
                    ( { model | timer = timer }, Cmd.none )

        UpdateSetTimeText newSetTimeText ->
            ( model |> updateSetTimeRemainingText newSetTimeText, Cmd.none )

        SetRemainingTime ->
            ( setTimeRemaining model, Cmd.none )

        Start ->
            ( model |> setTimerRunning True, Cmd.none )

        Stop ->
            ( model |> setTimerRunning False, Cmd.none )


updateSetTimeRemainingText : String -> Model -> Model
updateSetTimeRemainingText newSetTimeText model =
    { model | timeToSetAsText = newSetTimeText }


setTimeRemaining : Model -> Model
setTimeRemaining model =
    case timeToSet model of
        Ok newTime ->
            { model | timer = Timer.stoppedAtTime newTime }

        Err unparsableText ->
            model


setTimerRunning : Bool -> Model -> Model
setTimerRunning running model =
    { model | timer = model.timer |> Timer.setRunning running }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.timer of
        ActiveTimer _ ->
            Time.every 1000 (\ignored -> Tick)

        _ ->
            Sub.none


view : Model -> Html Msg
view { timer, timeToSetAsText } =
    let
        setTime =
            parseTime timeToSetAsText
    in
    div []
        [ viewTimer timer timeToSetAsText setTime
        , viewSounds
        ]


viewTimer : Timer -> String -> ParsedTime -> Html Msg
viewTimer timer timeToSetAsText setTime =
    div []
        [ viewTimeRemaining timer
        , viewTimerControls
        , viewSetTimerControls timeToSetAsText setTime
        ]


viewTimeRemaining : Timer -> Html Msg
viewTimeRemaining timer =
    div [] [ TypedTime.toString TypedTime.Seconds (Timer.timeRemainingInSeconds timer |> toFloat |> TypedTime.seconds) |> text ]


viewTimerControls =
    div []
        [ button [ onClick Stop ] [ text "stop" ]
        , button [ onClick Start ] [ text "start" ]
        , viewOptionalTickButton False -- REFACTOR Move this parameter up to the entry point.
        ]


viewOptionalTickButton : Bool -> Html Msg
viewOptionalTickButton drawIt =
    if drawIt then
        div [] [ button [ onClick Tick ] [ text "tick" ] ]

    else
        div [] []


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


viewSounds : Html Msg
viewSounds =
    div [ id "sounds" ]
        [ viewAudioWithoutControls "expired" "/audio/timer-expired.mp3"
        , viewAudioWithoutControls "warning" "/audio/timer-warning.mp3"
        ]


viewAudioWithoutControls : String -> String -> Html Msg
viewAudioWithoutControls elementId elementSrcUrl =
    audio
        [ id elementId
        , src elementSrcUrl
        , controls False
        ]
        []
