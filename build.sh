#!/usr/bin/env bash

# Build Elm code
pushd elm
elm make src/Main.elm --output=target/countdown-timer-elm.js
popd

