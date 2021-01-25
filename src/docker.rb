class Docker < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'up', 'Start docker-compose'
  def up
    system('docker-compose up -d')
  end

end