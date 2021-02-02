class Project < Thor

  def initialize(args = nil, options = nil, config = nil)
    super

    @config = $datastore.config
    @options = $datastore.options
  end

  desc 'mark', 'mark project folder active to run commands'
  def mark(project = nil)
    if project.nil?
      Dir.chdir($datastore.config.get($datastore.key_store::PROJECT_DIR))
      list = Dir.glob('*').select { |f| File.directory? f }

      prompt = TTY::Prompt.new
      project = prompt.select("Choose Project?") do |menu|
        list.each do |l|
          menu.choice l
        end
      end
    end

    $datastore.config.set($datastore.key_store::PROJECT_ACTIVE, project)
  end

  desc 'unmark', 'Unmark active project folder'
  def unmark
    $datastore.config.del($datastore.key_store::PROJECT_ACTIVE)
  end

end