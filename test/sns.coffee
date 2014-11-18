chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'sns', ->
  beforeEach ->
    @robot =
      router:
      	post: sinon.spy()
      emit: sinon.spy()
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/sns')(@robot)

  it 'registers a post router', ->
    expect(@robot.router.post).to.have.been.calledWith('/hubot/sns')
