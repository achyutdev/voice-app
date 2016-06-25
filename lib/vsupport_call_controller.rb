# encoding: utf-8
require 'fileutils'

class VsupportCallController < Adhearsion::CallController
  include GoogleTTSPlugin::ControllerMethods

  before_call do
    #something if needed
  end

  after_call #call this method

  def run
    answer
    define_option if verify_code
    #play option i) record new support ii) followup previous
    case @selected_option
    when 1
      record_new_support
    when 2
      followup_support
    else
      error_handler('invalid_option')
    end
    hangup
  end

  #-------------- Verify User---------------------------

  def verify_code
    error_handler unless Organization.isvalid_vsupport?('12')
    @org_id=Organization.org_id
  end


  def define_option
    say "Enter 1 for new support 2 for followup."
    code_entered=ask "", "",  #option for record new support or followup
      :timeout => 10,:limit => 1
    @selected_option=code_entered.utterance.to_i
  end


  #-----------------New  Support Record ----------------------

  def record_new_support
    #record new support
    record_support
    #generate random id and give them back
    give_vsupport_to_followup
    say "Thank you for your call !"
  end

  def record_support
    say "Start your recording after the beep. when you done press #"
    record_result = record :start_beep => true, :max_duration => 60, :interruptible=> '#'
    file_name=record_result.source_uri.to_s.chomp+".wav"
    hangup if !call.active?
    @vsuport_id,@vsupport_number=Vsupport.update_new_support(@org_id,TIME_DATE,file_name,call.from)
    directory="#{ROOT_PATH}/vsupport/query_files"
    FileUtils.mkdir_p(directory)
    FileUtils.cp("/var/punchblock/record/#{file_name}","#{directory}/#{file_name}")
  end

  def give_vsupport_to_followup
    say 'your support number is :'
    v_number=@vsupport_number.to_s.split(//)
    2.times do |i|
      v_number.each do |num|
        say "#{num}"
      end
      say 'Once again, your support number is:' if i==0
    end
  end


  #---------------- Follow Up Support ------------------------
  def followup_support
    @tries=0
    ask_for_support_number until @result
    error_handler ('support_number') if !@result or @tries == 2
    give_support
    say "thanks for calling."
    hangup
  end

  def ask_for_followup_support_number
    say 'Enter your Support Number.'
    code_entered=ask "", "",
      :timeout => 10, :limit => 5, :terminator => '#'
    @entered_vsupport_number=code_entered.utterance.to_s
  end

  def ask_for_support_number
    begin
      ask_for_followup_support_number
      @result= Vsupport.isvalid_entered_vsupport_number(@entered_vsupport_number)
      raise 'ERROR: Entered VSupport number wrong.' unless @result
    rescue Exception => e
      hangup if @tries==2
      puts e.message
      @tries +=1
      if @tries==2
        say 'This is your last chance.'
      else
        say 'You entered wrong number.'
      end
    end
  end

  def give_support
    support=Vsupport.check_status
    if support.status
      say "Your support is solved. Listen what they say about your question."
      file_name=support.solution_file
      puts file_name
      file_path="#{ROOT_PATH}/vsupport/answered_files"
      play "/#{file_path}/#{file_name}"
    else
      say  "support is in process."
    end

  end



  #------------Error handler--------------------------------
  def error_handler(type) #entered number and entered pasword error
    case type
    when 'code'
      #play error notice board number
      say 'dial code is not register in our system'
    when 'support_number'
      #for follow up wrong support number entered
      say 'dial number is not valid support number'
    end
    hangup
  end

end
