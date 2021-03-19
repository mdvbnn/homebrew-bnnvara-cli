class Docker < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'stop', 'Stop active docker-compose'
  def stop
    dir = @config.get($datastore.key_store::DOCKER_ACTIVE)

    unless dir.nil?
      system("cd #{dir} && docker-compose stop")
      @config.del $datastore.key_store::DOCKER_ACTIVE
    end

  end

  desc 'down', 'Stop active docker-compose and remove containers'
  def down
    prompt = TTY::Prompt.new

    result = prompt.yes?("Are you sure? This wil remove the docker containers. ")

    unless result
      unless @config.get($datastore.key_store::DOCKER_ACTIVE).nil?
        dir = @config.get($datastore.key_store::DOCKER_ACTIVE)
        system("cd #{dir} && docker-compose down")
        @config.del($datastore.key_store::DOCKER_ACTIVE)
      end
    end

  end

  desc 'up', 'Start docker-compose'
  def up(project = nil)
    prompt = TTY::Prompt.new

    if project.nil?
      if @config.get($datastore.key_store::PROJECT_ACTIVE).nil?
        if Dir.pwd.include? @config.get($datastore.key_store::PROJECT_DIR)
          puts 'No project marked as active'.red
          result = prompt.yes?("Run in current directory ? " + Dir.pwd)
          if result
            up_command(Dir.pwd)
          end
        else
          puts "This location is not within project directory #{@config.get($datastore.key_store::PROJECT_DIR)}".red
        end
      else
        project_dir = File.join(@config.get($datastore.key_store::PROJECT_DIR), @config.get($datastore.key_store::PROJECT_ACTIVE))
        up_command(project_dir)
      end
    else
      project_dir2 = File.join(@config.get($datastore.key_store::PROJECT_DIR), project)
      up_command(project_dir2)
    end
  end

  desc 'exec', 'Execute command in a docker container'
  def exec(docker, command)
    unless @config.get($datastore.key_store::DOCKER_ACTIVE).nil?
      dir = @config.get($datastore.key_store::DOCKER_ACTIVE)
      system("cd #{dir} && docker-compose exec #{docker} #{command}")
    end
  end

  private
  def up_command(project_dir)
    if File.exist? File.join(project_dir, 'docker-compose.yaml')
      system("cd #{project_dir} && docker-compose up -d")
      @config.set($datastore.key_store::DOCKER_ACTIVE, project_dir)
    elsif File.exist? File.join(project_dir, 'docker-compose.yml')
      system("cd #{project_dir} && docker-compose up -d")
      @config.set($datastore.key_store::DOCKER_ACTIVE, project_dir)
    else
      puts "Can't find docker compose file".red
      exit 1
    end
  end

end