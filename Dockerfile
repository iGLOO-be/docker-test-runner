
FROM ubuntu:14.04
MAINTAINER iGLOO Team <support@igloo.be>

RUN echo "# Generate locales" && \
    locale-gen en_US.UTF-8 && \
    locale-gen fr_BE.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_CTYPE=fr_BE.UTF-8 && \

    echo "# Upgrade apt" && \
    apt-get update && apt-get upgrade -y && \

    echo "# Install common dev dependencies via apt" && \
    apt-get install -y git \
                       curl \
                       wget \
                       rsync \
                       patch \
                       build-essential \
                       python \
                       mysql-client-5.6 \
                       libfreetype6 libfontconfig \
                       default-jre \
                       firefox \
                       xvfb \
                       && \

    echo "# Install google-chrome-stable" && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get remove -y apt-transport-https && \

    echo "# Install nvm" && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash && \
    cp /root/.nvm/nvm.sh /etc/profile.d/ && \

    echo "# Install rvm" && \
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby && \
    echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc && \

    echo "# Install wkhtmltopdf" && \
    apt-get install -y gdebi \
                       libssl-dev \
                       libxrender-dev && \
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    rm -rf wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    apt-get remove -y gdebi && \

    echo "# Clean" && \
    apt-get clean && apt-get autoremove -y && rm -rf /tmp/*
