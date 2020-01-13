module Timer exposing
    ( Timer(..)
    , expiredTimer
    , setRunning
    , tick
    , timeRemainingInSeconds
    )

import TypedTime exposing (TypedTime, seconds)


type Timer
    = ActiveTimer TypedTime
    | PausedTimer TypedTime
    | ExpiredTimer


expiredTimer : Timer
expiredTimer =
    ExpiredTimer


tickTimer : (TypedTime -> Timer) -> TypedTime -> Timer
tickTimer timerConstructor timeRemaining =
    let
        newTimeRemaining =
            TypedTime.sub timeRemaining (seconds 1)
    in
    if TypedTime.gt newTimeRemaining (seconds 0) then
        timerConstructor newTimeRemaining

    else
        ExpiredTimer


tick : Timer -> Timer
tick timer =
    case timer of
        ActiveTimer timeRemaining ->
            tickTimer ActiveTimer timeRemaining

        PausedTimer timeRemaining ->
            tickTimer PausedTimer timeRemaining

        _ ->
            timer


timeRemainingInSeconds : Timer -> Int
timeRemainingInSeconds timer =
    case timer of
        PausedTimer timeRemaining ->
            TypedTime.toSeconds timeRemaining |> floor

        ActiveTimer timeRemaining ->
            TypedTime.toSeconds timeRemaining |> floor

        _ ->
            0


setRunning : Bool -> Timer -> Timer
setRunning running timer =
    case ( timer, running ) of
        ( PausedTimer timeRemaining, True ) ->
            ActiveTimer timeRemaining

        ( ActiveTimer timeRemaining, False ) ->
            PausedTimer timeRemaining

        _ ->
            timer
