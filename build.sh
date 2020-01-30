#!/usr/bin/env bash

# Build Elm code
pushd elm
elm make src/Main.elm --output=../jekyll/source/javascripts/countdown-timer-elm.js
popd

