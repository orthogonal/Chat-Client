Chatapp1::Application.routes.draw do
  post  'new_message' => 'chat#new_message'
  post  'change_room' => 'chat#change_room'
  match ':controller(/:action)'
end
