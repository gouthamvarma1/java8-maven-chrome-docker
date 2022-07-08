FROM maven:3.8.6-jdk-8

# Google Chrome

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
        && apt-get update -qqy \
        && apt-get -qqy install curl unzip


#Getting Chrome Supported Version wrt to chrome driver
RUN CHROME_DRIVER_SUPPORTED_CHROME_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`\
        &&echo $CHROME_DRIVER_SUPPORTED_CHROME_VERSION\
        && apt-get -qqy install google-chrome-stable="$CHROME_DRIVER_SUPPORTED_CHROME_VERSION-1"\
        && rm /etc/apt/sources.list.d/google-chrome.list \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
        && sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

# Installing  ChromeDriver
RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
        && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
        && rm -rf /opt/chromedriver \
        && unzip /tmp/chromedriver_linux64.zip -d /opt \
        && rm /tmp/chromedriver_linux64.zip \
        && mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
        && chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
        && ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

# Updating Xvfb for vitual display

RUN apt-get update -qqy \
        && apt-get -qqy install xvfb \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/*