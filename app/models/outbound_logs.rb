class OutboundLog <ActiveRecord::Base
	belongs_to :outbound_lists	
	has_many :outbound_status
end