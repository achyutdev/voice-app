# encoding: utf-8

require 'call_controllers/simon_game'

Adhearsion.router do

  # Specify your call routes, directing calls with particular attributes to a controller
 unaccepting do
  	route 'authorized_user', Init
  end
end
