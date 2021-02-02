class Docker < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'up', 'Start docker-compose'
  def up
    unless @config.get($datastore.key_store::PROJECT_ACTIVE).nil?
      project_dir = File.join(@config.get($datastore.key_store::PROJECT_DIR), @config.get($datastore.key_store::PROJECT_ACTIVE))
      if Dir.exist? project_dir
        system('cd ' + project_dir + 'docker-compose up -d')
      end
    end

    if Dir.pwd.include? $datastore.key_store::PROJECT_DIR
      system('docker-compose up -d')
    end
  end

end