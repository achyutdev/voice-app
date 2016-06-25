class Project<ActiveRecord::Base

  def self.isvalid?(code)
    project=self.find_by(user_call_code:code)
    if project.nil?
      return false
    else
      return true
    end
  end

  def self.caller_id_required?(code)
    self.find_by(user_call_code:code).caller_id_validation
  end

  def self.caller_id_file(code)
    self.find_by(user_call_code:code).caller_id_file
  end

end
