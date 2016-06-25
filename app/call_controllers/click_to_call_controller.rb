# this is only test call controller 
# VoiceInn call controller are in default 'lib/' directory 

class ClickToCallController < Adhearsion::CallController

  def run
    answer
    # dial next_number
    play '/home/achyut/adcs/static/audio/welcome-to-our-sys.gsm'
    hangup
  end

  private

  def next_number
    metadata[:org_id]
  end
end

