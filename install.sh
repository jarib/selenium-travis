#/bin/sh

set -x

CHROME_REVISION="229207"
CHROMEDRIVER_VERSION="2.4"
sh -e /etc/init.d/xvfb start

if [[ "$WD_SPEC_DRIVER" = "chrome" ]]; then
  sudo apt-get install -y unzip libxss1
  curl -L -O "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/$CHROME_REVISION/chrome-linux.zip"
  unzip chrome-linux.zip
  curl -L -O "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
  mv chromedriver chrome-linux/chromedriver
  chmod +x chrome-linux/chromedriver
  sudo chmod 1777 /dev/shm
fi

