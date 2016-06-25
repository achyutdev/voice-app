class OutboundStatus<ActiveRecord::Base
  self.table_name = "outbound_status"
  belongs_to :outbound_logs
end
