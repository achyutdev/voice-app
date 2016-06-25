class Vboard < ActiveRecord::Base
  def self.is_secure?(id)
    @notice_info=self.find_by(:org_id=>id)
    return true if @notice_info.password
  end

  def self.is_password_valid?(password)
    stored_password=@notice_info.password
    return true if stored_password ==password
  end

  def self.notice_file
    @notice_info.notice_file
  end
end
