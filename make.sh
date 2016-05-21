#!/bin/bash

elm make spec/testRunner.elm --output spec.js && node spec.js \
&& elm make src/main.elm
