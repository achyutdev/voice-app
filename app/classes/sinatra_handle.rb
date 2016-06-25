require 'sinatra'

#test api for joining two call
get '/call/:user1/:user2' do
  num1="SIP/"+params[:user1]
  num2="SIP/"+params[:user2]
  id=1
  "Call setup between #{:user1} and #{:user2}"
  c2c_start!(num1,num2,id)
end

#Outbound call :  with schedular
get '/schedular/:time/:outbound_call_id' do
  outbound_id     = params[:outboundcall_id]
  time            = params[:time]
  schedular       = Schedular.new(id,time)
  schedular.start_it!
  "schedular started"
end

#Outbound call :  without schedular
get '/outboundcall/:id' do
  q=QueueHandler.new(params[:id])
  q.make_queue
  q.make_call
  'calling'
end

#Vsupport : forward call handler
get '/vsupport/forward_call/:org_id/:contact' do
  "success"
  org_id      = params[:org_id]
  contact     = params[:contact]
  controller  = "SupportForwardCall"
  contact_num = "SIP/" + contact.to_s
  forward     = MakeCall.new(contact_num, controller, org_id)
  forward.start!
end

#Vsupport : call back to user again
get '/test' do
  "Hello"
end
