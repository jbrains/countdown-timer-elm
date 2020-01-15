#!/usr/bin/env bash

# Build Elm code
pushd elm
elm make src/Main.elm --output=target/countdown-timer-elm.js
popd

# Publish Elm code to Jekyll site
rsync -aiP elm/target/ jekyll/source/javascripts