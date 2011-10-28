Description
===========

A hubot script for generating memes at http://memegenerator.net

Usage
=====

`hubot meme list`

`hubot meme create "generator name" "first line of text" "second line of text"`

The double quotes are necessary at this point.  The generator name
should come from the list command.

Installation
============

1.  Set up an account at http://memegenerator.net
2.  Set these two environment variables:
    * `MEME_GENERATOR_USER`
    * `MEME_GENERATOR_PASSWORD`
3.  Put meme.coffee in your hubot-scripts directory


