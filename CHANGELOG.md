# Changelog

## 0.1.7.1 / 2012-11-29

- Restore behaviour of LibWebSocket::OpeningHandshake::Client#url
- Fix for JRuby 1.7.0 in Ruby 1.9 mode

## 0.1.6.1 / 2012-11-19

- Fix `uninitialized constant LibWebSocket::OpeningHandshake::Forwardable` error

## 0.1.6 / 2012-11-18

- Migrate to websocket gem
- Remove most of deprecated and not working code
- Frame migration is last thing that prevents this gem to support drafts 00-17(RFC)

## 0.1.5 / 2012-07-27

- Fixed problem caused by invalid draft 10 support

## 0.1.4 / 2012-07-13

- New gemspec and bundler files
- Fixed some encoding errors
- Fixes for JRuby

## 0.1.3 / 2012-03-21

- add "addressable" gem to dependencies
- fix some branch errors from 0.1.2

## 0.1.1 / 2011-10-24

- Fixed bug that prevented query strings from being included in requests

## 0.1.0 / 2010-12-05

- new features:
  - rename Handshake to OpeningHandshake(we will need ClosingHandshake in new drafts)
- bugfixes:
  - relax response string parser(allow custom text after 'HTTP/1.1 101')

## 0.0.4 / 2010-12-04

- initial release
