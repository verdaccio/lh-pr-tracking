# Verdaccio PR tracking

(this repo just a basic fork of https://github.com/rust-lang-nursery/rustc-pr-tracking) and (https://github.com/paulirish/lh-pr-tracking)

This repository tracks the status of Verdaccio's PRs over time: all the data is
available in the CSV format, and it's updated daily by a bot running on GitHub
CI. A [Web dashboard](https://verdaccio.github.io/verdaccio-pr-tracking/) is
also available with graphs of the collected data.

The content of this repository is released under the MIT license.

## Adding new graphs

If you want to track data for a new graph, you need to create a new `.csv` file
in the `data` directory with just the first row. The first cell in that row is
the query you want to use (with `{param}` as the placeholder), and in the other
cells the various strings that will replace `{param}` in the query. For example,
this row counts how much PRs each of the listed labels has:

```
label:{param},S-waiting-on-review,S-waiting-on-author
```

You can add pretty labels to each column by putting the label after `|`: this
way it's possible to hide hard-to-read query params. If you also want to show a
graph on the web dashboard, add this snippet to the `index.html` file:

```
<div class="graph" id="your-file-name-without-extension">
    <h2>Your section title</h2>
    <canvas></canvas>
</div>
```

You can then run the updater script to populate today's data automatically.

## Running the updater script locally

The updater script can also be run locally: you just need to have Python 3 and
the python-requests library installed.

```
# Update all the CSV files in the data/ directory
$ python3 updater.py

# Update just the data/sample.csv file
$ python3 updater.py data/sample.csv
```

If the `GITHUB_TOKEN` environment variable is present, the script will use it
to authenticate with the GitHub API: it can work fine without it, but the API
rate limits are pretty low for unauthenticated requests (don't worry, the
script will wait for the limits to expire, it will just take more time to
finish).

**Do not run** the `ci.sh` script: it's meant to be run by Travis, and it will
push new commits to this repository.
