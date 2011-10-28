#
# Set these environment variables to your memegenerator.net login:
#  MEME_GENERATOR_USER
#  MEME_GENERATOR_PASSWORD
#
# Interact with memegenerator.net
#
# Generate a meme:
#  meme "text0" "text1"
#
# You have to use quotes, and it always does the wolf for now

# Utility commands surrounding Hubot uptime.
module.exports = (robot) ->

  user =  process.env.MEME_GENERATOR_USER
  password = process.env.MEME_GENERATOR_PASSWORD

  robot.respond /(meme )[^"]*$/i, (msg) ->
    msg.send "please use quotes"

  # this is pretty nasty
  robot.respond /(meme )"([^"]*)"( "([^"]*)")?/i, (msg) ->
    t0 = msg.match[2]
    t1 = msg.match[4]

    msg.http("http://version1.api.memegenerator.net/Instance_Create")
      .query({
        languageCode: "en"
        generatorID: 45,
        imageID: 20,
        text0: t0,
        text1: t1,
        username: user,
        password: password
      })
      .get() (err, res, body) ->
        info = JSON.parse(body)
        if info.success

          # you have to fetch the instanceURL first, before its
          #  available in the cache.  Just do this to seed the cache
          # so we can link the image

          # except getting it like this does not seem to be enough

          msg.send info.result.instanceUrl
          msg.http(info.result.instanceUrl).get()
            

          msg.send "http://memegenerator.net" + info.result.instanceImageUrl
        else
          msg.send "Fail: " + body



