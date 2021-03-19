#!/usr/bin/env ruby

class Config < Thor

  def initialize(args = nil, options = nil, config = nil)
    super
    $datastore = DataStore.new(self.options)

    @config = $datastore.config
  end

  desc 'setup', 'Setup bnnvara cli config'
  def setup
    prompt = TTY::Prompt.new
    result = nil
    force = $datastore.options[:force]

    unless @config.get($datastore.key_store::SETUP_RUN)
      result = prompt.collect do
        key(:dir).ask("Project Directory ? ~/")
        key(:git).select("Git clone method", {ssh: 'SSH', https: 'HTTPS'})
      end
    end

    if force
      result = prompt.collect do
        key(:dir).ask("Project Directory ? ~/")
        key(:git).select("Git clone method", {ssh: 'SSH', https: 'HTTPS'})
      end
    end

    unless result.nil?
      project_dir = File.join(Dir.home, result[:dir])
      @config.set($datastore.key_store::PROJECT_DIR, project_dir)
      @config.set($datastore.key_store::SETUP_RUN, true)
      @config.set($datastore.key_store::GIT_CLONE_METHOD, result[:git])
    end

    @config.persist
  end

  desc 'read', 'list the config'
  def read
    config_hash = @config.get_config.to_h

    table = TTY::Table.new
    table << %w[ KEY VALUE ]

    config_hash.each do |key, value|
      if value.is_a? Hash
        table2 = TTY::Table.new
        table2 << ['Section', key.to_s] << :separator

        value.each do |key2, value2|
          table2 << [key2.to_s, value2.to_s]
        end

        puts table2.render(:ascii)
      else
        table << [key.to_s, value.to_s]
      end
    end

    puts "Overig:"
    puts table.render(:ascii)
  end

  desc 'check', 'Check if everything is configured'
  def check
    if $datastore.options[:verbose]
      puts 'Checking config'
      print 'Is Setup been called? '
      sleep 0.5

      if @config.get($datastore.key_store::SETUP_RUN)
        puts 'YES'.green

        print 'Project Directory '
        sleep 0.5
        puts "#{@config.get($datastore.key_store::PROJECT_DIR)}".green
      else
        puts 'NO'.red
      end

      check_bin('Checking for git ... ', "git")
      check_bin('Checking for docker ... ', "docker")
      check_bin('Checking for docker compose ... ', "docker-compose")
      check_bin('Checking for composer ... ', "composer")
    else
      if @config.get($datastore.key_store::SETUP_RUN) &&
        !@config.get($datastore.key_store::PROJECT_DIR).nil? &&
        check_bin('Checking for git ... ', "git") &&
        check_bin('Checking for docker ... ', "docker") &&
        check_bin('Checking for docker compose ... ', "docker-compose") &&
        check_bin('Checking for composer ... ', "composer")

        puts "Everything configured correctly".green
      end
    end
  end

  private
  def check_bin(txt, bin, yes = 'YES', no = 'NO', time = 0.5)
    if $datastore.options[:verbose]
      print txt
      sleep time
      puts yes.green if TTY::Which.exist?(bin)
      puts no.red unless TTY::Which.exist?(bin)
    end

    TTY::Which.exist?(bin)
  end
end