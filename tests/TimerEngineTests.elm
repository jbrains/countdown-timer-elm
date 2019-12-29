module TimerEngineTests exposing (allTests)

import Expect
import Fuzz exposing (..)
import Test exposing (..)
import Timer exposing (..)


allTests : Test
allTests =
    describe "When running the timer"
        [ describe "tick causes the timer to tick down one second"
            [ fuzz (intRange 1 10000) "boring happy path" <|
                \startTimeInSeconds ->
                    activeTimerSetTo startTimeInSeconds
                        |> tick
                        |> timeRemainingInSeconds
                        |> Expect.equal (startTimeInSeconds - 1)
            , test "expired timer doesn't tick" <|
                \() ->
                    expiredTimer
                        |> tick
                        |> timeRemainingInSeconds
                        |> Expect.equal 0
            ]
        ]
