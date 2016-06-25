class OutboundCallClass
  @@calls = {}
  attr_accessor :number, :controller, :id

  def initialize(number, id,  controller)
    @number     = number
    @controller = controller
    @id         = id
    @status     = :not_started
    @answer     = false
    @@calls[id] = self
  end

  def start!
    @ahn_call = Adhearsion::OutboundCall.originate number,
      from:                "voiceInn",
      controller:           Object.const_get(@controller),
      controller_metadata: {required_id: id, outbound_call: true}
  end
  def status
    puts 'checking status..'
    if @ahn_call
      @ahn_call.active? ? :active : :ended
    else
      :ended
    end
  end

  def hangup!
    @ahn_call.hangup
  end

  def self.calls
    @@calls
  end

  def self.find(id)
    @@calls[id]
  end
end
