module Timer exposing
    ( Timer
    , activeTimerSetTo
    , expiredTimer
    , tick
    , timeRemainingInSeconds
    )

import TypedTime exposing (TypedTime, seconds)


type Timer
    = ActiveTimer { timeRemaining : TypedTime }
    | ExpiredTimer


activeTimerSetTo : TypedTime -> Timer
activeTimerSetTo timeRemaining =
    ActiveTimer { timeRemaining = timeRemaining }


expiredTimer : Timer
expiredTimer =
    ExpiredTimer


tick : Timer -> Timer
tick timer =
    case timer of
        ActiveTimer properties ->
            let
                newTimeRemaining =
                    TypedTime.sub properties.timeRemaining (seconds 1)
            in
            if TypedTime.gt newTimeRemaining (seconds 0) then
                ActiveTimer { properties | timeRemaining = newTimeRemaining }

            else
                ExpiredTimer

        ExpiredTimer ->
            timer


timeRemainingInSeconds : Timer -> Int
timeRemainingInSeconds timer =
    case timer of
        ActiveTimer { timeRemaining } ->
            TypedTime.toSeconds timeRemaining |> floor

        ExpiredTimer ->
            0
