# encoding: utf-8

class SupportCallback < Adhearsion::CallController
  include GoogleTTSPlugin::ControllerMethods

  before_call do
    @support=Vsupport.find_by(:id =>@metadata)
  end
  after_call do
    #do some thing
    end

    def run
      answer
      say "I am from VoiceInn. They replay your question. Should i play it now."
      say "if yes press 1 else press 2."
      if dial_num == 1
        play "#{ROOT_PATH}/vsupport/answered_files/#{@support.solution_file}"
        say "Thank you for your participation."
      else
        say "I will remine you later."
      end
      hangup
    end

    def dial_num
      code_entered=ask "", "", #change playing file
        :timeout => 10,:limit => 1
      return code_entered.utterance.to_i
    end
  end
