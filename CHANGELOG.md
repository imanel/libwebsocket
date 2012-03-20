# Changelog

## 0.2.0 / 2012-03-20

- New gemspec and bundler files
- Roll back from OpeningHandshake to Handshake - there were reports that it's too confusing
- Fixes for cookie handling
- Support for drafts 10+
- Error codes are handled according to specification

## 0.1.1 / 2011-10-24

- Fixed bug that prevented query strings from being included in requests

## 0.1.0 / 2010-12-05

- new features:
  - rename Handshake to OpeningHandshake(we will need ClosingHandshake in new drafts)
- bugfixes:
  - relax response string parser(allow custom text after 'HTTP/1.1 101')

## 0.0.4 / 2010-12-04

- initial release
