class Git < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'clone', 'Setup new repo'
  def clone(repo)
    repo_dir = File.join( @config.get($datastore.key_store::PROJECT_DIR), repo )

    if Dir.exist? repo_dir
      puts "Directory already exists".red
      exit 1
    else
      Dir.chdir @config.get($datastore.key_store::PROJECT_DIR)
      system("git clone #{get_repo_url(repo)}")
      Dir.chdir repo_dir
      system("cp phpunit.xml.dist phpunit.xml")
      system('sed "s/SENTRY_DSN=.*/SENTRY_DSN=/g" .env > .env.test')
      invoke 'docker:stop', ''
      invoke 'docker:up', repo
      invoke 'docker:exec', 'php', 'composer install'
    end

=begin

#ProjectFolder="${HOME}/Projects/${1}"
#git clone https://korneelweverbnn@bitbucket.org/bnnvara/$1.git $ProjectFolder
cd $ProjectFolder
cp phpunit.xml.dist phpunit.xml
sed "s/SENTRY_DSN=.*/SENTRY_DSN=/g" .env > .env.test
docker kill $(docker ps -q)
docker-compose up &
docker exec -ti $(docker ps -q -f name=php) bin/console composer install &

=end


  end

  private
  def get_repo_url(repo)
    if @config.get($datastore.key_store::GIT_CLONE_METHOD) == 'SSH'
      "git@bitbucket.org:bnnvara/#{repo}.git"
    else
      "http://bitbucket.org/bnnvara/#{repo}.git"
    end
  end
end