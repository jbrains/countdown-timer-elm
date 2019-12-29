module TimerEngineTests exposing (..)

import Expect
import Test exposing (..)


type Timer
    = ActiveTimer { timeRemaining : Int }


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


allTests : Test
allTests =
    describe "When running the timer"
        [ describe "tick causes the timer to tick down one second"
            [ test "boring happy path" <|
                let
                    activeTimerSetTo timeRemaining =
                        ActiveTimer { timeRemaining = timeRemaining }
                in
                \() -> activeTimerSetTo 100 |> tick |> timeRemainingInSeconds |> Expect.equal 99
            ]
        ]
