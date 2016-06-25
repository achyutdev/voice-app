# encoding: utf-8
require 'fileutils'

class SupportForwardCall < Adhearsion::CallController

  include GoogleTTSPlugin::ControllerMethods

  before_call do
    @support=Vsupport.find_by(:id =>@metadata) # metadata
  end
  
  after_call do
    SupportForwardCallLog.create(:support_id => @support.id, :time => Time.now.strftime("%F %T"), :forwarded_number =>call.to, :action => @action )
    if @action == "Query answer is recorded"
      status, solution_file = "solved", @file_name
    elsif @action == nil
      status, solution_file = "new", nil 
    else
      status, solution_file = "pending", nil
    end
    Vsupport.update(@metadata, :status => "solved", :solution_file => @file_name) #metadata
  end


  def run
    hangup if @support.nil?
    answer
    @action = nil
    say "you have query message. Do you like to listen it now."
    enter_num=dial_num("press 1 to listen, press 2 to later")
    if enter_num == 1
      listen_now
    elsif enter_num == 2
      remine_later("without listen message")
    else
      run
    end
    hangup unless call.active?
    # Forwarded number ====???
    say "Good Bye !"
    hangup
  end

  def dial_num(playing_file)
    say playing_file
    code_entered=ask "", "", #change playing file
      :timeout => 10,:limit => 1
    return code_entered.utterance.to_i
  end

  def listen_now
    say "Your message is. "
    query_file_name=@support.query_file
    puts query_file_name

    begin
      play "file://#{ROOT_PATH}/vsupport/query_files/#{query_file_name}"
      enter_num=dial_num("Enter 1 to record your answer. Press 2 to listen again. press 3 to remain me later.")
      flag, count = false, 0
      if enter_num == 1
        record_message
        puts "Returned"
      elsif enter_num == 2
        @action = "listen message" + count.to_s + "time"
        flag, count = true, count+1
      elsif enter_num == 3
        remine_later("after listen message")
      else
        flag = true
      end
    rescue Exception => e
      e.backtrace
      error
    end while flag

  end

  def record_message
    @action = 'Try to answer'
    say "Record your message after a Beep"

    record_result = record :start_beep => true, :max_duration => 60, :interruptible=> '#'
    @file_name=record_result.source_uri.to_s.chomp+".wav"

    puts @file_name
    directory="#{ROOT_PATH}/vsupport/answered_files"
    if !File.directory?(directory)
      FileUtils.mkdir_p(directory)
    end
    FileUtils.cp("/var/punchblock/record/#{@file_name}","#{directory}/#{@file_name}")
    @action = 'Query answer is recorded'
    say "your message is recorded. I will forward this message to user."
  end

  def remine_later(is_msg_listened)
    @action = "Remine me later : #{is_msg_listened}"
    say "I call you back."
  end

  #------------------- Error Handler -------------------------

  def error
    say "Error has occur !"
    hangup
  end
end
