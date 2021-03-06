require 'yaml'
require 'singleton'

#Singleton Class which parses
#the yml configuration file
#and returns config values


class Parser
  include Singleton
  CONFIG_FILE = 'config.yml'


  def initialize
    @config = YAML.load(File.read(CONFIG_FILE))
  end

  def db_name
    @config['db_name']
  end

  def db_password
    @config['db_password']
  end

  def db_user
    @config['db_user']
  end

end

