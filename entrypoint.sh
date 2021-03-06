#!/bin/sh

set -e
gem install bundler

# Install runtime for execjs, prettier
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
npm install --global prettier

echo '👍 ENTRYPOINT HAS STARTED—INSTALLING THE GEM BUNDLE'
bundle config path vendor/bundle
bundle install --jobs 4 --retry 3
bundle list | grep "jekyll ("
echo '👍 BUNDLE INSTALLED—BUILDING THE SITE'
bundle exec jekyll build
prettier -w _site/

echo '👍 THE SITE IS BUILT—PUSHING IT BACK TO GITHUB-PAGES'
cd _site
remote_repo="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" && \
remote_branch="gh-pages" && \
git init && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git add . && \
echo -n 'Files to Commit:' && ls -l | wc -l && \
git commit -m'action build' > /dev/null 2>&1 && \
git push --force $remote_repo master:$remote_branch > /dev/null 2>&1 && \
rm -fr .git && \
cd ../
echo '👍 GREAT SUCCESS!'
