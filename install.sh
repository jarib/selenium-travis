#/bin/sh

CHROME_REVISION=127410
sh -e /etc/init.d/xvfb start

if [[ "$WD_SPEC_DRIVER" = "chrome" ]]; then
  sudo apt-get install -y unzip libxss1
  curl -L -O "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux/$CHROME_REVISION/chrome-linux.zip"
  unzip chrome-linux.zip
  curl -L "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux/$CHROME_REVISION/chrome-linux.test/chromedriver" > chrome-linux/chromedriver
  chmod +x chrome-linux/chromedriver
fi

