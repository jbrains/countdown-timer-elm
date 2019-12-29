module TimerEngineTests exposing (..)

import Expect
import Test exposing (..)
import Timer exposing (activeTimerSetTo, tick, timeRemainingInSeconds)


allTests : Test
allTests =
    describe "When running the timer"
        [ describe "tick causes the timer to tick down one second"
            [ test "boring happy path" <|
                \() -> activeTimerSetTo 100 |> tick |> timeRemainingInSeconds |> Expect.equal 99
            ]
        ]
