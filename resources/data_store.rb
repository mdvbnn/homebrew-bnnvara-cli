#!/usr/bin/env ruby

class DataStore

  def initialize(options)
    @config = ConfigFile.new
    @config.load

    @options = options
  end

  def config
    @config
  end

  def options
    @options
  end
end