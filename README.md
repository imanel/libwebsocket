# LibWebSocket
[![Build Status](https://travis-ci.org/imanel/libwebsocket.png)](http://travis-ci.org/imanel/libwebsocket) [![Dependency Status](https://gemnasium.com/imanel/libwebsocket.png)](http://gemnasium.com/imanel/libwebsocket)

A WebSocket message parser/constructor. It is not a server and is not meant to
be one. It can be used in any server, event loop etc.

**Note:** this implementation is supporting only hixie -75 and -76 drafts. Current development of newer drafts are handled within [websocket-ruby](https://github.com/imanel/websocket-ruby) gem and if you are starting new project it will be best to use it instead of libwebsocket. However, if you are already using libwebsocket then you don't need to hurry with transition - this gem will use websocket-rack to support newer drafts.

## Copyright

Copyright (C) 2012, Bernard Potocki.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
