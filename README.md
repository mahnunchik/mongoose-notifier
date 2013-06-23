# mongoose-notifier

[Mongoose](https://github.com/LearnBoost/mongoose) lifecyle notification system through the [Redis](http://redis.io/commands#pubsub)

## Installation

```
$ npm install mongoose-notifier
```

## Features

* Notification other processes through publish resis's messages

## Events

* create
* update
* delete


## Usage

Apply plugin to schema
```
//user.js
var User = new Schema({ ... });
User.plugin(require('mongoose-notifier'));

var user = new User({ ... });
user.save();
```

Listen events in other processes
```
//worker.js
var client = redis.createClient();
client.on('message', function(channel, message){
  var data = JSON.parse(message)
  switch (data.type) {
    case 'create':
      var userID = data._id
      //send 'Hello' email
    case 'update':
      var userID = data._id
      //do smth
  }
});

client.subscribe('mongoose.user')
```

## API mongoose-notifier

mongoose lifecyle notification system through the redis

```
var notifier = require('mongoose-notifier');
var options = { ... }
User.plugin(notifier, options);
```

### Params:

* **Object** *options* 

* **String** *options.channel* Channel name

* **Function** *options.pack* Packer function

* **RedisClient** *options.redisClient* Redis client instance

* **String** *options.port* Redis port

* **String** *options.host* Redis host

* **Object** *options.redisOptions* Redis options


## License

(The MIT License)

Copyright (c) 2013 Eugeny Vlasenko <mahnunchik@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.