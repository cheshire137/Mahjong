# Mahjong

[![Build status](https://travis-ci.org/cheshire137/Mahjong.svg?branch=master)](https://travis-ci.org/cheshire137/Mahjong)

An implementation of [Mahjong solitaire](https://en.wikipedia.org/wiki/Mahjong_solitaire) as a Rails app.

## How to Develop

You'll need Ruby 2+ and PostgreSQL.

    bundle install
    bundle exec rake db:create db:migrate

## How to Test

    bundle install
    bundle exec rake test

## How Tiles are Positioned

X coordinates are in black horizontally across the top, y coordinates are in pale blue vertically along the left, and z coordinates are in yellow. See the coordinates in [layouts/turtle.txt](layouts/turtle.txt).

![Tile position diagram](https://raw.githubusercontent.com/cheshire137/Mahjong/master/tile-diagram.png)

## Thanks

- [taksuyu/tile-art](https://github.com/taksuyu/tile-art) for the tile images.
- [Bulma.io](http://bulma.io/) for the CSS framework.
