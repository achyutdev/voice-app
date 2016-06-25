# encoding: utf-8
require 'active_record'
require 'rubygems'

#Give voice in web UI base path here
ROOT_PATH ="/home/#{ENV['USER']}/adcs/static/audio"

ahn_root_path = File.expand_path File.dirname('../')

Dir["#{ahn_root_path}/app/classes/*.rb"].each { |class_rb| require class_rb }
Dir["#{ahn_root_path}/app/models/*.rb"].each  { |model_rb| require model_rb }
Dir["#{ahn_root_path}/app/call_controllers/*.rb"].each { |controller| require controller }


Adhearsion.config do |config|

  config.development do |dev|
    dev.platform.logging.level = :warn
  end

#Database
##Active record integration
  config.adhearsion_activerecord do |config|
    config.username = "*****"
    config.password = "*****"
    config.database = "*****"
    config.adapter  = "mysql2" # i.e. mysql, sqlite3
    config.host     = "localhost" # i.e. localhost
    config.port     = "3306".to_i # i.e. 3306
  end

#TTS
##using google tts

  config.google_tts_plugin do |config|
    config.save_to      = "/home/#{ENV['USER']}/connect/audio" # make sure you have permissions write
    config.language     = "en"
    config.speed        = "100%"
    config.volume       = "130%"
    #config.google_tts  = "change here if google changes tts uri"
    config.mpg123_path  = "/usr/bin/mpg123" # change it to your path or nil if not installed (but required on centos)
    config.sox_path     = "/usr/bin/sox"       # change it to your path
  end


  # DRB Settings
  # config.adhearsion_drb.host          = "0.0.0.0"
  # config.adhearsion_drb.acl.allow     = ["all"]
  # config.adhearsion_drb.shared_object = AMI.new

  #http request handler using verginia
  # HTTP Settings
  config.virginia.host    =   "0.0.0.0"
  config.virginia.port    =   8080
  # config.virginia.handler = SinatraHandle

  ##
  # Use with Asterisk
  #
  config.punchblock.platform  = :asterisk # Use Asterisk
  config.punchblock.username  = "********" # Your AMI username
  config.punchblock.password  = "*******" # Your AMI password
  config.punchblock.host      = "*******" # Your AMI host

end
