class QueueHandler
  attr_accessor :id

  def initialize(id)
      @id=id
  end
  
  def make_queue
     @required_id , @controller= OutboundList.find_controller(@id)
    selected_contact_id=LinkOutboundContact.where(:outbound_call_id => @id)
    @contact_in_queue=Queue.new
    selected_contact_id.each do |for_each_one|
      @contact_in_queue << ContactList.find_by(:id => for_each_one.outbound_contact_id).contact_number
    end
    return true
  end
  
  def make_call
    until @contact_in_queue.empty?
      @id=rand(10000)
      number=@contact_in_queue.pop
      puts number
      calling_number="SIP/"+number.to_s
      call_status=OutboundCallClass.new(calling_number, @required_id, @controller)
      if call_status.status!=:active
        puts 'calling ..'
        call_status.start!
      else
        'try to sleep ..'
        sleep(1) until call_status.status == :ended
      end
    end
  end
end
