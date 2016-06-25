# # encoding: utf-8
# #
# ##
# #This call controller is used for testing proposes 

# require 'twitter'
# require 'gmail'

# class Test < Adhearsion::CallController
#   include GoogleTTSPlugin::ControllerMethods
#   # before_call do
#   #   @client = Twitter::REST::Client.new do |config|
#   #     config.consumer_key        = "XXXXXXXXXXXXXXXXXXXXX"
#   #     config.consumer_secret     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#   #     config.access_token        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#   #     config.access_token_secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#   #   end
#   # end
#   def run
#     answer
#     say "Call coming form #{call.from}"

#     gmail = Gmail.new("Gmail_name", "PPPPPPPPPP")
#     puts gmail.inspect
#     gmail.logout


#     # puts @client.inspect
#     # @client.update("tweeting from #adhearsion application using api. you have a call from #{call.from} #asterisk")
#     # t = Time.now
#     # date = t.to_date
#     # date_format = 'ABdY'
#     # execute "SayUnixTime", t.to_i, date_format
#     # play_time date, :format => date_format

#     # play 'demo-echotest'
#     # execute 'Echo'
#     # play 'demo-echodone'
#     hangup
#   end
# end
