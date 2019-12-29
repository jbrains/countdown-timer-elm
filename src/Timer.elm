module Timer exposing
    ( Timer
    , activeTimerSetTo
    , expiredTimer
    , tick
    , timeRemainingInSeconds
    )


type Timer
    = ActiveTimer { timeRemaining : Int }
    | ExpiredTimer


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
                    properties.timeRemaining - 1
            in
            if newTimeRemaining > 0 then
                ActiveTimer { properties | timeRemaining = properties.timeRemaining - 1 }

            else
                ExpiredTimer

        ExpiredTimer ->
            timer


timeRemainingInSeconds : Timer -> Int
timeRemainingInSeconds timer =
    case timer of
        ActiveTimer { timeRemaining } ->
            timeRemaining

        ExpiredTimer ->
            0
