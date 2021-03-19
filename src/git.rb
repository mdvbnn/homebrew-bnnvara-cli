require 'yaml'

class Git < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'clone', 'Setup new repo'

  def clone(repo)
    repo_dir = File.join(@config.get($datastore.key_store::PROJECT_DIR), repo)

    if Dir.exist? repo_dir
      puts "Directory already exists".red
      exit 1
    else
      Dir.chdir @config.get($datastore.key_store::PROJECT_DIR)
      system("git clone #{get_repo_url(repo)}")
      Dir.chdir repo_dir
      system("cp phpunit.xml.dist phpunit.xml")
      if File.exist? '.env'
        system('sed "s/SENTRY_DSN=.*/SENTRY_DSN=/g" .env')
      end
      if File.exist? '.env.test'
        system('sed "s/SENTRY_DSN=.*/SENTRY_DSN=/g" .env.test')
      end

      docker_stop

      dc = nil
      if File.exist? 'docker-compose.yml'
        dc = YAML.load_file('docker-compose.yml')
      elsif File.exist? 'docker-compose.yaml'
        dc = YAML.load_file('docker-compose.yaml')
      end


      prompt = TTY::Prompt.new
      service = prompt.select("Which service runs PHP?") do |menu|
        dc["services"].each do |k, v|
          menu.choice k
        end
      end

      invoke 'docker:up', repo
      invoke 'docker:exec', [service, 'composer install']
    end

  end

  private

  def get_repo_url(repo)
    if @config.get($datastore.key_store::GIT_CLONE_METHOD) == 'SSH'
      "git@bitbucket.org:bnnvara/#{repo}.git"
    else
      "http://bitbucket.org/bnnvara/#{repo}.git"
    end
  end

  def docker_stop
    dir = @config.get($datastore.key_store::DOCKER_ACTIVE)

    unless dir.nil?
      system("cd #{dir} && docker-compose stop")
      @config.del $datastore.key_store::DOCKER_ACTIVE
    end

  end
end