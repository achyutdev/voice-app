class Vsupport < ActiveRecord::Base
   def self.update_new_support(org_id,time,query,number)
    #generate random unique vsupport
    v_num=random_vsupport_number
    newly_created=self.create(:org_id=>org_id,:time=>time,:query_file=>query,:phone_number=>number,:vsupport_number=>v_num)
    return newly_created.id,newly_created.vsupport_number
  end

  def self.isvalid_entered_vsupport_number(number)
    @support=self.find_by(:vsupport_number=>number)
    if @support.nil?
      puts ' false..'
      return false
    else
      puts 'true'
      return true
    end
  end

  def self.check_status
    @support
  end

  def self.support(code)
    @support = self.find_by(:id => code)
  end

  private
  def self.random_vsupport_number
    random_num=rand(100000)
    #make it unique
  end
end