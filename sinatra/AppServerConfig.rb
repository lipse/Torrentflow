require 'config'

class AppServerConfig < BaseConfig
  AppserverConfigFilename = "sinatra.conf"

  def initialize
    @urlBasePath = ""
    @listenPort = 4567
  end
  
  def self.configFileName
    AppserverConfigFilename
  end

  attr_accessor :listenPort

  # Logging
  attr_accessor :logFile
  attr_accessor :logLevel
  attr_accessor :logSize
  attr_accessor :logCount
  attr_accessor :logRequests
  attr_accessor :urlBasePath

  protected
  def handleYaml(yaml, dontValidateDirs = false)
    @listenPort = yaml['port'].to_i

    @logFile = yaml['log_file']
    if ! @logFile
      $logger.error "The configuration file log_file setting is missing"
      return false
    end
    @logLevel = validateAndConvertLogLevel(yaml['log_level'], 'log_level')
    return false if ! @logLevel
    @logSize = yaml['log_size']
    if @logSize
      return false if ! validateInteger(@logSize, 'log_size')
    else
      $logger.error "The configuration file log_size setting is missing"
      return false
    end

    @logCount = yaml['log_size']
    if @logCount
      return false if ! validateInteger(@logCount, 'log_size')
    else
      $logger.error "The configuration file log_size setting is missing"
      return false
    end

    @logRequests = yaml['log_requests']
    if @logRequests
      return false if ! validateBoolean(@logRequests, 'log_requests')
    end
  
    @urlBasePath = yaml['url_path']
    if @urlBasePath
      @urlBasePath += '/' if @urlBasePath !~ /\/$/
    else
      @urlBasePath = ""
    end

    true
  end
end
