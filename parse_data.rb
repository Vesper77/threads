require 'yaml'

class Parser
  CONFIG_FILE = 'config.yml'
  class << self

    def config
      @config ||= YAML.load(File.read(CONFIG_FILE))
    end

  end
end

