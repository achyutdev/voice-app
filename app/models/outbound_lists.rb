class OutboundList<ActiveRecord::Base
	has_many :outbound_logs
	has_many :contact_lists, through: :link_outbound_contacts
	has_many :link_outbound_contacts

	def self.find_controller(id)
		outbound=self.find_by(:id => id)
		if outbound == 0
			required_id =Project.find_by(:id => outbound.vboard_survey_id).user_call_code
			controller="Project"
		else
			required_id = id
			controller="VboardCallController"
		end
		return required_id,controller
	end
end