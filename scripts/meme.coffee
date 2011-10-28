#
# Set these environment variables to your memegenerator.net login:
#  MEME_GENERATOR_USER
#  MEME_GENERATOR_PASSWORD
#
# Interact with memegenerator.net
#
# List all available memes:
#  hubot meme list
# Generate a meme:
#  hubot meme create "generator" "text0" "text1"
#
# You have to use quotes, and it always does the wolf for now


module.exports = (robot) ->

  user =  process.env.MEME_GENERATOR_USER
  password = process.env.MEME_GENERATOR_PASSWORD

  # popular generators, taken from 
  # http://version1.api.memegenerator.net/Generators_Select_ByPopular 
  # 
  # The imageID here is the integer part of the name in imageUrl.  So 
  # if imageUrl is "/cache/images/400x/0/162/166088.jpg", then imageID
  # should be 166088.

  # probably it would be better to fetch this list on start up instead of
  # hard coding it

  generators = 
    "philosoraptor":
      generatorID: 17,
      imageID: 984
    "frog":
      generatorID:3,
      imageID: 203
    "insanity wolf":
      generatorID: 45,
      imageID: 984,
    "y u no":
      generatorID: 2,
      imageID: 166088
    "ducreux":
      generatorID: 54,
      imageID: 42
    "forever alone":
      generatorID: 116,
      imageID: 142442
    "success kid":
      generatorID: 121,
      imageID: 1031
    "interesting man":
      generatorID: 74,
      imageID: 2485
    "trollface":
      generatorID: 68,
      imageID: 84688

  robot.respond /meme( help)?$/i, (msg) ->
    msg.send "Commands:\n meme list\n meme create \"generator\" \"text0\" \"text1\""

  robot.respond /(meme )list/i, (msg) ->
    list = (g for g of generators)
    msg.send "Available generators:\n " + list.join("\n ")

  robot.respond /(meme )create(.*)/i, (msg) ->
    args = msg.match[2]

    # split it up on double quotes.  We expect to get three arguments,
    # total
    bits = args.split('"')
    if bits.length != 7
      msg.send "I don't understand that"
    else
      # now bits looks like this:
      [ '', 'generator name', '', 'text1', '', 'text2']

      generator_name = bits[1]
      t0 = bits[3]
      t1 = bits[5]

      if generators[generator_name]
        generator = generators[bits[1]]

        msg.http("http://version1.api.memegenerator.net/Instance_Create")
          .query({
            languageCode: "en"
            generatorID: generator.generatorID,
            imageID: generator.imageID,
            text0: t0,
            text1: t1,
            username: user,
            password: password
          })
          .get() (err, res, body) ->
            info = JSON.parse(body)
            if info.success

              # you have to fetch the instanceURL first, before its
              # available in the cache.  Just do this to seed the cache
              # so we can link the image

              msg.http(info.result.instanceUrl).get() (err, res, body) ->
                # msg.send res.headers
            
              msg.send "http://memegenerator.net" + info.result.instanceImageUrl
            else
              msg.send "Fail: " + body



