# Description:
#   <description of the scripts functionality>
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SNS_URL
#
# Commands:
#   None
#
# URLs:
#   /hubot/sns
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   mdouglass

Options =
  url:     process.env.HUBOT_SNS_URL or '/hubot/sns'

class Listener
  constructor: (field, regex, callback) ->
    @field = field
    @regex = regex
    @callback = callback

  call: (msg) ->
    if match = msg[@field].match @regex
      message =
        topic:     msg.TopicArn
        subject:   msg.Subject
        message:   msg.Message
        messageId: msg.MessageId
      @callback message
      true
    else
      false

class SNS
  constructor: (robot) ->
    @robot = robot
    @listeners = []

    @robot.router.post Options.url, (req, res) => @onMessage req, res

  subject: (regex, callback) ->
    @listeners.push new Listener 'Subject', regex, callback

  message: (regex, callback) ->
    @listeners.push new Listener 'Message', regex, callback

  topic: (regex, callback) ->
    @listeners.push new Listener 'TopicArn', regex, callback

  onMessage: (req, res) ->
    chunks = []

    req.on 'data', (chunk) ->
      chunks.push(chunk)

    req.on 'end', () =>
      res.end()

      req.body = JSON.parse(chunks.join(''))

      @deliver req if @validate req

  validate: (req) ->
    # Needs to validate that this message is a properly formatted and sign Amazon SNS message
    true

  deliver: (req) ->
    @robot.logger.info req.body
    if req.body.Type == 'SubscriptionConfirmation'
      @confirmSubscription req.body
    else if req.body.Type == 'Notification'
      @notify req.body

  confirmSubscription: (msg) ->
    @robot.http(msg.SubscribeURL).get() (err, res, body) =>
      return

  notify: (msg) ->
    for listener in @listeners
      listener.call msg

module.exports = (robot) ->

  robot.sns = new SNS robot

  robot.emit 'sns:ready', robot.sns
