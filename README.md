# jbrains learns some Elm

I don't know what I'm doing, but I'm trying.

This is a countdown timer that I'll eventually be able to use in my training courses. 
I've built this before in Javascript, so I'm trying to build it again in Elm.

## Please Help!

I don't know what I'm doing! I need your help. I especially want these things:

- Make illegal states unrepresentable.
- Learn idioms.
- Learn useful libraries.

Please submit pull requests or add comments. Optionally, [ping me on Twitter](//twitter.com/jbrains) to tell
me something. Send me articles to read. Thank you!

## Build and Run

I use Jekyll to get a simple application running with an embedded web server. Do these things once:

1. Install `ruby` 2.6.2. (See `jekyll/.ruby-version`)
2. `pushd jekyll && gem install bundler && popd`
3. `chmod u+x build.sh`

To run the web server:

1. `cd jekyll && bundle install && bundle exec jekyll serve --port=4001`
2. Visit <https://localhost:4001>, the "timer page".

The HTTP port number is a free choice; I use 4001 here only as an example.

To build the Elm code:

1. `./build.sh`
2. Monitor the `jekyll serve` window to see that the JavaScript code has been reloaded, then refresh the browser window where you loaded the timer page.

## Inbox

- Significantly less ugliness.
