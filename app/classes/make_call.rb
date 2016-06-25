class MakeCall
  @@calls = {}
  attr_accessor :number, :org_id, :id

  def initialize(number,controller,org_id, id=1)
    @number  = number
    @org_id = org_id
    @controller =controller
    # @id         = id
    @status     = :not_started
    @answer     =false
    @@calls[id] = self
  end

  def start!
    @ahn_call = Adhearsion::OutboundCall.originate number,
      from:                 "voiceInn",
      controller:            Object.const_get(@controller) ,
      controller_metadata:   {org_id: @org_id, controller: @controller}
  end

  def status
    if @ahn_call
      @ahn_call.active? ? true : false
    else
      false
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
