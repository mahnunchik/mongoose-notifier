
assert = require 'assert'
mongoose = require 'mongoose'
Schema = mongoose.Schema
redis = require 'redis'
notifier = require '../'

dbName = 'mongodb://localhost/test_notifier'

describe 'Mongoose notifier', ()->
  
  @timeout(0)

  before (done)->
    db = mongoose.createConnection(dbName)
    User = db.model 'user', {name: String}
    User.collection.drop (err, res)->
      if err? and err.errmsg != 'ns not found'
        return done(err)
      db.close (err)->
        done(err)

  describe 'default chanel name', ()->
    it 'create event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111110'
        name: 'John'

      client = redis.createClient()
      client.on 'message', (channel, message)->
        assert.equal channel, 'mongoose:user'
        data = JSON.parse message
        assert.equal data.type, 'create'
        assert.equal data._id, '111111111111111111111110'
        client.end()
        db.close (err)->
          done(err)

      client.subscribe 'mongoose:user'
      client.on 'subscribe', ()->
        user.save (err, user)->
          done(err) if err?

    it 'update event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111111'
        name: 'John'
      user.save (err, user)->
        done(err) if err?

        client = redis.createClient()
        client.on 'message', (channel, message)->
          assert.equal channel, 'mongoose:user'
          data = JSON.parse message
          assert.equal data.type, 'update'
          assert.equal data._id, '111111111111111111111111'
          client.end()
          db.close (err)->
            done(err)
        client.subscribe 'mongoose:user'

        client.on 'subscribe', ()->
          user.name = 'David'
          user.save (err)->
            done(err) if err?

    it 'delete event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111112'
        name: 'John'
      user.save (err, user)->
        done(err) if err?

        client = redis.createClient()
        client.on 'message', (channel, message)->
          assert.equal channel, 'mongoose:user'
          data = JSON.parse message
          assert.equal data.type, 'delete'
          assert.equal data._id, '111111111111111111111112'
          client.end()
          done()
        client.subscribe 'mongoose:user'

        client.on 'subscribe', ()->
          user.remove (err)->
            done(err) if err?


  describe 'custom chanel name', ()->
    it 'create event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier, {channel: 'mychannel'}
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111113'
        name: 'John'

      client = redis.createClient()
      client.on 'message', (channel, message)->
        assert.equal channel, 'mychannel:user'
        data = JSON.parse message
        assert.equal data.type, 'create'
        assert.equal data._id, '111111111111111111111113'
        client.end()
        db.close (err)->
          done(err)

      client.subscribe 'mychannel:user'
      client.on 'subscribe', ()->
        user.save (err, user)->
          done(err) if err?

    it 'update event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier, {channel: 'mychannel'}
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111114'
        name: 'John'
      user.save (err, user)->
        done(err) if err?

        client = redis.createClient()
        client.on 'message', (channel, message)->
          assert.equal channel, 'mychannel:user'
          data = JSON.parse message
          assert.equal data.type, 'update'
          assert.equal data._id, '111111111111111111111114'
          client.end()
          db.close (err)->
            done(err)
        client.subscribe 'mychannel:user'

        client.on 'subscribe', ()->
          user.name = 'David'
          user.save (err)->
            done(err) if err?

    it 'delete event', (done)->
      db = mongoose.createConnection(dbName)
      UserSchema = new Schema {name: String}
      UserSchema.plugin notifier, {channel: 'mychannel'}
      User = db.model 'user', UserSchema
      user = new User
        _id: '111111111111111111111115'
        name: 'John'
      user.save (err, user)->
        done(err) if err?

        client = redis.createClient()
        client.on 'message', (channel, message)->
          assert.equal channel, 'mychannel:user'
          data = JSON.parse message
          assert.equal data.type, 'delete'
          assert.equal data._id, '111111111111111111111115'
          client.end()
          done()
        client.subscribe 'mychannel:user'

        client.on 'subscribe', ()->
          user.remove (err)->
            done(err) if err?
