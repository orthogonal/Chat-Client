Chatapp1::Application.routes.draw do
  post  'new_message' => 'chat#new_message'
  match ':controller(/:action)'
end
