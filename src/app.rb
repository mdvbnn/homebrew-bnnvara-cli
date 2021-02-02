#!/usr/bin/env ruby

require_relative '../bootstrap/bootstrap'

class App < Thor
  method_option :force, :type => :boolean, :aliases => "-f"
  method_option :verbose, :type => :boolean, :aliases => "-v"

  def initialize(args = nil, options = nil, config = nil)
    super

    $datastore = DataStore.new(self.options)
    ObjectSpace.define_finalizer(self, proc { $datastore.config.persist })
  end

  desc "config", "config commands"
  subcommand "config", Config

  desc 'docker', 'Docker Compose Commands'
  subcommand "docker", Docker

  desc 'project', 'Project commands'
  subcommand "project", Project

end