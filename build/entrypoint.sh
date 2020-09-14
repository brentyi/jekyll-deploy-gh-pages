#!/bin/sh

set -e
gem install bundler

# Install runtime for execjs, prettier
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
npm install --global prettier

echo '👍 ENTRYPOINT HAS STARTED—INSTALLING THE GEM BUNDLE'
bundle install > /dev/null 2>&1
bundle list | grep "jekyll ("
echo '👍 BUNDLE INSTALLED—BUILDING THE SITE'
bundle exec jekyll build
prettier -w _site/
echo '👍 THE SITE IS BUILT—GREAT SUCCESS'
