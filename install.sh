#/bin/sh

set -x

export CHROME_REVISION="228611"
export CHROMEDRIVER_VERSION="2.4"

if [[ "$WD_SPEC_DRIVER" = "chrome" ]]; then
  sudo chmod 1777 /dev/shm

  sudo apt-get install -y unzip libxss1

  curl -L -O "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${CHROME_REVISION}/chrome-linux.zip"
  unzip chrome-linux.zip

  # chrome sandbox doesn't currently work on travis: https://github.com/travis-ci/travis-ci/issues/938
  sudo chown root:root chrome-linux/chrome_sandbox
  sudo chmod 4755 chrome-linux/chrome_sandbox
  export CHROME_DEVEL_SANDBOX="$PWD/chrome-linux/chrome_sandbox"

  curl -L -O "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
  unzip chromedriver_linux64.zip

  mv chromedriver chrome-linux/chromedriver
  chmod +x chrome-linux/chromedriver
fi

sh -e /etc/init.d/xvfb start


