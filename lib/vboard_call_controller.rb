# encoding: utf-8

class VboardCallController < Adhearsion::CallController
  include GoogleTTSPlugin::ControllerMethods
  
  def run
    answer
    say "You have a call from VoiceInn."
    #verify noticboard number
    # verify_code_entered

    #check for secure message
    require_password if notice_board_msg_secure?

    #play notice board message
    play_notice_file
    hangup
  end

  def verify_code_entered
    error_handler('code') unless Organization.isvalid_notice_board?(@metadata)
    #set org_id
    @org_id=Organization.org_id
  end

  def notice_board_msg_secure?
    return true if NoticeBoard.is_secure?(@org_id)
  end

  def require_password
    tries = 0
    password=nil
    until NoticeBoard.is_password_valid?(password)
      tries+=1
      if tries<=3
        password=ask_for_password
      else
        error_handler('password')
      end
    end
  end

  def ask_for_password
    raw_pw=ask "", "#{ROOT_PATH}/welcome-to-our-sys.gsm",
      :timeout => 10, :terminator => '#'
    password=raw_pw.utterance
  end

  def play_notice_file
    file_name=NoticeBoard.notice_file
    puts file_name #play file
    play "file://#{ROOT_PATH}/welcome-to-our-sys.gsm"
  end

  #-------------------ERROR Handler----------------------------

  def error_handler(type) #entered number and entered pasword error
    case type
    when 'code'
      #play error notice board number
    when 'password'
      #play password error
    end
    hangup
  end
end
