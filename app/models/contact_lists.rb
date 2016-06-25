class ContactList < ActiveRecord::Base
	has_many :outbound_calls, through: :link_outbound_contacts
	has_many :link_outbound_contacts
end
