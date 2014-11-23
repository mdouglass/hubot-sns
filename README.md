# hubot-sns 
[![Build Status](https://travis-ci.org/mdouglass/hubot-sns.svg?branch=master)](https://travis-ci.org/mdouglass/hubot-sns)

Hubot script for receiving notifications from AWS Simple Notification Service

## Quick Start

1. Subscribe Hubot to SNS
hubot-sns adds an endpoint at `/hubot/sns` that receives both subscription requests and notifications . By default, hubot-sns will confirm any subscription requests sent from SNS so you can simply subscribe your hubot in the console and it will automatically start receiving notifications.

2. Handle incoming notifications
hubot-sns sends an event when notifications are received. You can use `robot.on` to handle these events. Your event handler can choose to handle all notifications or add individual handlers for specific topics.

```coffeescript
# scripts/your_script.coffee
module.exports = (robot) ->

  # Handle all notifications
  robot.on "sns:notification", (msg) ->
    """
    Received notification:
      TopicArn:   #{msg.topicArn}
      Topic:      #{msg.topic}
      Message Id: #{msg.messageId}
      Subject:    #{msg.subject}
      Message:    #{msg.message}
    """

  # Handle a specific topic (named mytopic in this example):
  robot.on "sns:notification:mytopic", (msg) ->
    """
    Received notification:
      TopicArn:   #{msg.topicArn}
      Topic:      #{msg.topic}
      Message Id: #{msg.messageId}
      Subject:    #{msg.subject}
      Message:    #{msg.message}
    """
```
