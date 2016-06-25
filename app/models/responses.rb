class Response<ActiveRecord::Base

  def self.update_response(id,number,time)
    response={project_id:id, time:time, phone_number:number}
    result=self.create(response)
    if result
      r_id=self.find_by(project_id:id,time:time, phone_number:number).id
    end
  end

  def self.update_phone_number(response_id,callerid)
    self.update(response_id, :phone_number=>callerid)
  end
end
