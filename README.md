# hubot-sns 
[![Build Status](https://travis-ci.org/mdouglass/hubot-sns.svg?branch=master)](https://travis-ci.org/mdouglass/hubot-sns)

Hubot script for receiving notifications from AWS Simple Notification Service

## Quick Start

hubot-sns works by sending events when notifications are received. You can use `robot.on` to handle these events. You can choose to handle all notifications in one handler or add handlers for specific topics.

Handle all notifications:
```coffeescript
# scripts/your_script.coffee
module.exports = (robot) ->
  robot.on "sns:notification", (msg) ->
    """
    Received notification:
      TopicArn:   #{msg.topicArn}
      Topic:      #{msg.topic}
      Message Id: #{msg.messageId}
      Subject:    #{msg.subject}
      Message:    #{msg.message}
    """
```

Handle a specific topic (named mytopic in this example):
```coffeescript
# scripts/your_script.coffee
module.exports = (robot) ->
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
