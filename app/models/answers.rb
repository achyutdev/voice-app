class Answer<ActiveRecord::Base
  def self.answer_table_update(response_id,question_id,file_name=nil,value=nil)
    result=self.new(response_id: response_id, question_id: question_id, file_name:file_name, value:value)
    result.save
  end
end