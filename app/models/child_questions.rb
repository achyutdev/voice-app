class ChildQuestion<ActiveRecord::Base
  def self.child_question?(question_id)
    if question_id==0
      return false
      # elsif !self.find_by(question_number: question_id).next_question.nil?
      #   puts "next question finding true"
      #   return true
    else
      return true
    end
  end


  def self.find_child_question_id(parent_question_id,input=nil)
    begin
      child_question_id=self.find_by(question_number: parent_question_id, input_value: input).next_question.to_i
      return child_question_id
    rescue Exception => e
      return 'ERROR'
    end
  end
end
