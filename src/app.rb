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

  desc 'project', 'mark project folder active to run commands'

  def project(project = nil)
    if project.nil?
      Dir.chdir($datastore.config.get('project.dir'))
      list = Dir.glob('*').select { |f| File.directory? f }

      prompt = TTY::Prompt.new
      project = prompt.select("Choose Project?") do |menu|
        list.each do |l|
          menu.choice l
        end
      end
    end

    $datastore.config.set('project.selected', project)
  end

end