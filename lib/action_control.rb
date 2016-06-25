# encoding: utf-8
require 'fileutils'

class ActionControl < Adhearsion::CallController
  before_call do
    @survey_data=Project.find_by(user_call_code:@metadata)
    @questions=Question.where(project_id:@survey_data.id)
  end

  def run
    time=Time.new
    @time=time.strftime("%Y-%m-%d %H:%M:%S")

    play_msg('greeting') if @survey_data.start_info == '1'
    survey
    play_msg('goodbye') if @survey_data.concluding_info == '1'
  end

  #--------------------------CALLER ID VALIDATION-----------------------------------

  def caller_id_validation
    if !@call_from.include? "unknown"
      @caller_number = @call_from
    else
      entered_number=caller_id_error
      if valid_number?(entered_number)
        @caller_number=entered_number
      else
        entered_number_error
      end
    end
  end

  def caller_id_error
    cid_file_name=@survey_data.caller_id_file
    number=ask "", "#{ROOT_PATH}/#{@metadata}/callerid_file/#{cid_file_name}",
      :timeout => 10, :terminator => '#'
    number=number.utterance.to_s
  end

  def valid_number?(num)
    return false unless  num.length==8 or 10
    return false unless  num[0...-8].include?"98" or num[0...-8].include?"0"
    return true
  end


  #---------------------GREETING & GOOD BYE ------------------------------------------

  def play_msg(message)
    if message == 'greeting'
      filename=@survey_data.start_info_file
    elsif message == 'goodbye'
      filename=@survey_data.concluding_info_file
    else
      file_not_exist
    end
    directory="#{ROOT_PATH}/#{@metadata}/callerid_file/#{filename}"
    file_not_exist unless directory_exists?(directory)
    play "file://#{directory}"
  end



  #--------------------------SURVEY SECTION-----------------------------------------------

  def survey
    @parent_question_id=@questions.find_by(is_first=1).id         
    @call_from=call.from.partition(" ").last.delete "</>"

    #caller id check
    cid_msg_play_at=@survey_data.caller_id_validation
    caller_id_validation if cid_msg_play_at=='start'

    if !@caller_number
      @caller_number=@call_from
    end
    update_response
    play_each_question while ChildQuestion.child_question?(@parent_question_id)
    caller_id_validation if cid_msg_play_at=='end'
    update_number_in_response
  end


  def play_each_question
    input=nil
    parent_question=@questions.find_by(id: @parent_question_id).question_file
    @directory="#{ROOT_PATH}/#{@metadata}/question/#{parent_question}"
    file_not_exist unless directory_exists?(@directory)
    question_type=@questions.find_by(id: @parent_question_id).question_type

    case question_type.to_i
    when 1
      play "file://#{@directory}"
      record_answer
    when 2
      save_dial
    when 3
      input=find_input
    when 4
      give_info
    else
      logger.error "Question Type mismatch \n Fix error by editing question type of question no #{parent_question_id} "
      format_error
    end
    @parent_question_id=ChildQuestion.find_child_question_id(@parent_question_id,input)
  end

  def update_response
    hangup if !call.active?
    @response_id=Response.update_response(@survey_data.id,@caller_number,@time)
  end

  def update_number_in_response
    hangup if !call.active?
    Response.update_phone_number(@response_id,@caller_number)
  end

  def find_input
    entered_input=ask "", "#{@directory}",
      :timeout => 10, :terminator => '#', :limit =>1
    input=entered_input.utterance.to_s
    return input
  end


  def record_answer
    record_result = record :start_beep => true, :max_duration => 60, :interruptible=> '#'
    value=nil
    file_name=record_result.source_uri.to_s.chomp+".wav"
    record=Answer.answer_table_update(@response_id,@parent_question_id,file_name,value)
    directory="#{ROOT_PATH}/#{@metadata}/answer"
    if !File.directory?(directory)
      FileUtils.mkdir_p(directory)
    end
    FileUtils.cp("/var/punchblock/record/#{file_name}","#{directory}/#{file_name}")
  end


  def save_dial
    entered_input=ask "", "#{@directory}",
      :timeout => 10, :terminator => '#'
    file_name=nil
    value=entered_input.utterance.to_i
    record=Answer.answer_table_update(@response_id,@parent_question_id,file_name,value)
  end

  def give_info
    play "file://#{@directory}"
    hangup
  end

  def directory_exists?(directory)
    File.file?(directory)
  end

  #####----------Error Handling Section---------------------------- ######

  def audio_file_format_invalid
    play "file://#{ROOT_PATH}/config_error.gsm"
    logger.error "\n Error : audio_file_format_invalid ...\nERROR in: \n\t #{caller[0]}"
    hangup
  end

  def question_manage_error
    play "file://#{ROOT_PATH}/config_error.gsm"
    logger.error "Question Type mismatch \n Fix error by editing question type of question no #{parent_question_id} "
    hangup
  end

  def file_not_exist
    play "file://#{ROOT_PATH}/config_error.gsm"
    logger.error "Error : audio file not exist in corresponding directory...\nError in :\n\t#{caller[0][/`.*'/][1..-2]}"
    hangup
  end

  def format_error
    play "file://#{ROOT_PATH}/config_error.gsm"
    hangup
  end

  def entered_number_error
    play "file://#{ROOT_PATH}/config_error.gsm"
    logger.error "Error : entered caller id length error.\n Dial your correct caller id."
    hangup
  end

end
