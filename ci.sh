#!/bin/bash
# Copyright (c) 2018 The Rust Project Developers
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -euo pipefail
IFS=$'\n\t'


GIT_COMMIT_MESSAGE="update pr stats"
GIT_EMAIL="verdacciobot@users.noreply.github.com"
GIT_NAME="Verdaccio Bot"
GIT_REPO="verdaccio/verdaccio-pr-tracking"
GIT_BRANCH="master"


if [[ -z "${GITHUB_ACTIONS}" ]]; then
    echo "Error: this script is meant to be run on GitHub Actions."
    exit 1
fi


if [[ -z "${GITHUB_TOKEN}" ]]; then
    echo "Error: the \$GITHUB_TOKEN environment variable is not set!"
    exit 1
fi

python3 -m pip install -r requirements.txt


git checkout "${GIT_BRANCH}"
python3 updater.py verdaccio/verdaccio
python3 updater.py verdaccio/charts


if git diff --quiet data/; then
    echo "No changes to commit."
else
    git status
    git add data/
    git -c "commit.gpgsign=false" \
        -c "user.name=${GIT_NAME}" \
        -c "user.email=${GIT_EMAIL}" \
        commit -m "${GIT_COMMIT_MESSAGE}"
    git push "https://x-token:${GITHUB_TOKEN}@github.com/${GIT_REPO}" "${GIT_BRANCH}"
fi
