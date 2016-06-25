# encoding: utf-8
#.... Adhearsion Project...
time=Time.new
TIME_DATE=time.strftime("%Y-%m-%d %H:%M:%S")

class Init < Adhearsion::CallController

  def run
    answer
    #costomized fightWAV section
    caller_no=call.to
    
    if caller_no=="8"
      code_entered=901
    else
      code_entered=find_valid_user_code
    end

    control=ActionControl.new(call,code_entered)
    control.exec(control)
    puts "hangup"
    hangup
    #Logginng all event and action after call hangup
  end

  def ask_for_user_code
    code_entered=ask "", "#{ROOT_PATH}/welcome-to-our-sys.gsm",
      :timeout => 10, :terminator => '#', :limit => 3
    code=code_entered.utterance.to_s
    return code
  end


  def find_valid_user_code
    tries = 0
    code = nil
    code_for_notice_board=nil
    until Project.isvalid?(code)
      tries+=1
      if tries<=3
        code=ask_for_user_code
        if code.length==2
          pass(NoticeBoardController,code)
        end
      else
        #error msg play
      end
    end
    return code
  end
end
