module Timer exposing
    ( Timer
    , activeTimerSetTo
    , tick
    , timeRemainingInSeconds
    )


type Timer
    = ActiveTimer { timeRemaining : Int }


activeTimerSetTo timeRemaining =
    ActiveTimer { timeRemaining = timeRemaining }


tick : Timer -> Timer
tick timer =
    case timer of
        ActiveTimer properties ->
            ActiveTimer { properties | timeRemaining = properties.timeRemaining - 1 }


timeRemainingInSeconds : Timer -> Int
timeRemainingInSeconds timer =
    case timer of
        ActiveTimer { timeRemaining } ->
            timeRemaining
