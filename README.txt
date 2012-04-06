
$ export SELENIUM_ROOT=$HOME/src/selenium 
$ cd $SELENIUM_ROOT
$ ./go //rb:gem:build
$ ./go ./go build/java/server/test/org/openqa/selenium/server-with-tests-standalone.jar
$ cd -
$ rake import
$ rake firefox # or remote,chrome,ie etc.