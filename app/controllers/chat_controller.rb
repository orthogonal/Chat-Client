class ChatController < ApplicationController
  require 'pusher'
  
  def index
    render(:action => "index")
  end
  
  def new_message

    Pusher['chatapp1'].trigger('new_message', {:message => 'Testing'})
    
    respond_to do |format|
      format.js {
        render(:text => "ok") 
      }
    end
  end
  
  
end
