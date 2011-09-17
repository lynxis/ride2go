require('./spec_helper')
log = require "../lib/logging"
describe "redis", ->
  mod = redis = redis_module = redis_client_spy = {}

  beforeEach ->
    redis_module = require "redis"
    redis = require "../lib/r2gredis"
    redis_client_spy = createSpyObj("my redis client", ["select"])

    mod = spyOnModule "redis", ["createClient"]
    spyOn(mod,"createClient").andReturn(redis_client_spy)


  describe ".client" , ->
    it "should return a redis client", ->

      #spyOn(mod,"createClient").andReturn(redis_client_spy)

      r = redis.client()
      
      expect(mod.createClient).toHaveBeenCalled()
      expect(r).toEqual(redis_client_spy)

  describe ".client in testmode" , ->
    it "should select the testdatabase if running in test enviroment", ->
      process.env.NODE_ENV = "test"
      r = redis.client()

      expect(redis_client_spy.select).toHaveBeenCalledWith(15)
