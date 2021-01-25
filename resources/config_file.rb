#!/usr/bin/env ruby

class ConfigFile

  def load
    config = TTY::Config.new
    config.append_path Dir.home
    config.filename = ".bnnvara"

    if config.exist?
      config.read
    end

    @config = config
  end

  def set(key, value)
    @config.set(key, value: value)
  end

  def get(key = nil)
    @config.fetch(key)
  end

  def get_config
    @config
  end

  def persist

    unless File.file? File.join(Dir.home, '.bnnvara.yml')
      out_file = File.new(File.join(Dir.home, '.bnnvara.yml'), "a")
      out_file.close
    end

    @config.write(force: true)
  end

end