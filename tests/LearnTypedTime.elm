module LearnTypedTime exposing (allTests)

import Expect
import Fuzz exposing (..)
import Test exposing (..)
import Timer exposing (..)
import TypedTime exposing (Unit(..), fromString, seconds)


allTests : Test
allTests =
    Test.concat [ parseTimeUnderOneMinuteInSeconds, failingTestsDueToParsingIssue ]


parseTimeUnderOneMinuteInSeconds : Test
parseTimeUnderOneMinuteInSeconds =
    let
        correctlyFormatTimeUnderOneMinuteInSeconds n =
            "00:" ++ String.padLeft 2 '0' (Debug.toString n)
    in
    fuzz (intRange 0 59) "We must format times under 1 minute as 00:xx due to https://github.com/jxxcarlson/elm-typed-time/issues/1" <|
        \secondsAsInt ->
            case secondsAsInt of
                0 ->
                    -- This case works by accident, so don't bother checking it
                    Expect.pass

                _ ->
                    let
                        typedTimeInSecondsAsText =
                            correctlyFormatTimeUnderOneMinuteInSeconds

                        expectedResultInMaybeSeconds =
                            toFloat >> seconds >> Just
                    in
                    typedTimeInSecondsAsText secondsAsInt
                        |> TypedTime.fromString Seconds
                        |> Expect.equal (expectedResultInMaybeSeconds secondsAsInt)


failingTestsDueToParsingIssue : Test
failingTestsDueToParsingIssue =
    fuzz (intRange 0 59) "Parsing 0:xx in seconds fails, because the parser expects '00' in place of '0'" <|
        \secondsAsInt ->
            case secondsAsInt of
                0 ->
                    -- This case works by accident, so don't bother checking it
                    Expect.pass

                _ ->
                    let
                        incorrectlyButReasonablyTryToFormatTimeUnderOneMinuteInSeconds n =
                            "0:"
                                ++ (if n >= 10 then
                                        Debug.toString n

                                    else
                                        "0" ++ Debug.toString n
                                   )

                        expectedResultInMaybeSeconds =
                            toFloat >> seconds >> Just
                    in
                    incorrectlyButReasonablyTryToFormatTimeUnderOneMinuteInSeconds secondsAsInt
                        |> TypedTime.fromString Seconds
                        |> Expect.notEqual (expectedResultInMaybeSeconds secondsAsInt)
                        |> Expect.onFail "Maybe this issue is fixed? https://github.com/jxxcarlson/elm-typed-time/issues/1"
