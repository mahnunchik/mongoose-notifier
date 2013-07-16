
###*
 *
 * mongoose lifecyle notification system through the redis
 *
 * @name mongoose-notifier
 *
 * @param {Schema} schema
 * @param {Object} options
 * @param {String} options.channel Channel name
 * @param {Function} options.pack Packer function
 * @param {RedisClient} options.redisClient Redis client instance
 * @param {String} options.port Redis port
 * @param {String} options.host Redis host
 * @param {Object} options.redisOptions Redis options
 *
###

module.exports = (schema, options={})->
  channelPrefix = options.channel || 'mongoose'
  pack = options.pack || JSON.stringify
  client = options.redisClient || require('redis').createClient(options.port, options.host, options.redisOptions)

  # Inspired by
  # https://github.com/Moveline/mongoose-eventify
  # https://github.com/fzaninotto/mongoose-lifecycle
  schema.pre 'save', (next)->
    @_isNew = @isNew
    next()

  schema.post 'save', ()->
    channel = "#{channelPrefix}:#{@constructor.modelName}"
    if @_isNew
      client.publish channel, pack({type: 'create', _id: @id})
    else
      client.publish channel, pack({type: 'update', _id: @id})

  schema.post 'remove', ()->
    channel = "#{channelPrefix}:#{@constructor.modelName}"
    client.publish channel, pack({type: 'delete', _id: @id})
    