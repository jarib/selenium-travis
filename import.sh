#!/bin/bash

rake clean
TARGETS="build/java/server/test/org/openqa/selenium/server-with-tests-standalone.jar //rb:gem:build"
export SELENIUM_ROOT=$HOME/src/git/selenium2 
cd $SELENIUM_ROOT
./go $TARGETS
cd -
rake import
bundle install