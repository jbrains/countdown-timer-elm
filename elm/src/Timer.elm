module Timer exposing
    ( Timer(..)
    , TimerEvent(..)
    , expiredTimer
    , setRunning
    , stoppedAtTime
    , tick
    , timeRemainingInSeconds
    )

import TypedTime exposing (TypedTime, seconds)


type Timer
    = ActiveTimer TypedTime
    | PausedTimer TypedTime
    | ExpiredTimer


type TimerEvent
    = Warning
    | Expired
    | Nothing


expiredTimer : Timer
expiredTimer =
    ExpiredTimer


tickTimer : (TypedTime -> Timer) -> TypedTime -> ( Timer, TimerEvent )
tickTimer timerConstructor timeRemaining =
    let
        newTimeRemaining =
            TypedTime.sub timeRemaining (seconds 1)
    in
    if TypedTime.gt newTimeRemaining (seconds 10) then
        ( timerConstructor newTimeRemaining, Nothing )

    else if TypedTime.gt newTimeRemaining (seconds 0) then
        ( timerConstructor newTimeRemaining, Warning )

    else
        ( ExpiredTimer, Expired )


tick : Timer -> ( Timer, TimerEvent )
tick timer =
    case timer of
        ActiveTimer timeRemaining ->
            tickTimer ActiveTimer timeRemaining

        PausedTimer timeRemaining ->
            tickTimer PausedTimer timeRemaining

        _ ->
            ( timer, Nothing )


timeRemainingInSeconds : Timer -> Int
timeRemainingInSeconds timer =
    case timer of
        PausedTimer timeRemaining ->
            TypedTime.toSeconds timeRemaining |> floor

        ActiveTimer timeRemaining ->
            TypedTime.toSeconds timeRemaining |> floor

        _ ->
            0


stoppedAtTime : TypedTime -> Timer
stoppedAtTime =
    PausedTimer


setRunning : Bool -> Timer -> Timer
setRunning running timer =
    case ( timer, running ) of
        ( PausedTimer timeRemaining, True ) ->
            ActiveTimer timeRemaining

        ( ActiveTimer timeRemaining, False ) ->
            stoppedAtTime timeRemaining

        _ ->
            timer
