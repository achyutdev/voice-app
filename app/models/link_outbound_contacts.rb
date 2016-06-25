class LinkOutboundContact < ActiveRecord::Base
  belongs_to :outbound_calls
  belongs_to :contact_lists
end
