RSSslurp
========

Peril slurper to consume arbitrary RSS feeds.

## Hacking

To hack on RSSslurp:

```bash
cd ${PROJECTS_HOME}
git clone git@github.com:rackerlabs/rssslurp.git
cd rssslurp

# You'll need to fill in a few configuration options.
cp config.json.example config.json
${EDITOR} config.json

# Install dependencies.
bundle install

# Kick it off. Logs go to stdout. Ctrl-C to kill it.
bundle exec ruby rssslurp.rb
```
