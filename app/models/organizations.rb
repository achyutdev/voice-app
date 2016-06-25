class Organization < ActiveRecord::Base
  def self.isvalid_notice_board?(code)
    @require_code=self.find_by(:notice_board=>code)
    if @require_code.nil?
      return false
    else
      return true
    end
  end

  def self.isvalid_vsupport?(code)
    @require_code=self.find_by(:vsupport=>code)
    if @require_code.nil?
      return false
    else
      return true
    end
  end

  def self.org_id
    org_id=@require_code.id
  end
end

