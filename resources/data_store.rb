#!/usr/bin/env ruby

class DataStore

  def initialize(options)
    @config = ConfigFile.new
    @config.load

    @options = options

    @key_store = ConfigKeyStore
  end

  def config
    @config
  end

  def options
    @options
  end

  def key_store
    @key_store
  end
end