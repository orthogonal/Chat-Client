class ChatController < ApplicationController
  require 'pusher'
  
  @@usrid = -1
  
  def index
    ip = request.remote_ip
    usr = User.where("ip = ?", ip)
    if (usr.length > 0)
      @@usrid = usr.first.id
    else
      usr = User.new
      usr.ip = ip
      usr.save
      usr = User.where("ip = ?", ip)
      @@usrid = usr.first.id
    end
    @msgs = Message.order("id ASC").limit(10)
    render(:action => "index")
  end
  
  def new_message
    if (params[:message])
      msg = Message.new
      msg.message = params[:message]
      msg.user_id = @@usrid
      msg.save
        
      Pusher['chatapp1'].trigger('new_message', {:message => params[:message], :username => params[:username]})
    end
    
    respond_to do |format|
      format.js {
        render(:text => "ok") 
      }
    end
  end
  
  
end
