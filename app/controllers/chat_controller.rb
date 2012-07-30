class ChatController < ApplicationController
  require 'pusher'
  
  def index
    ip = request.remote_ip
    usr = User.where("ip = ?", ip)
    if (usr.length > 0)
      session[:usrid] = usr.first.id
      session[:username] = usr.first.username
    else
      usr = User.new
      usr.ip = ip
      usr.username = "Guest"
      usr.save
      usr = User.where("ip = ?", ip)
      session[:usrid] = usr.first.id
    end
    session[:roomid] = 1
    @msgs = Message.where("room_id = ?", session[:roomid]).order("id DESC").limit(10).reverse
    @name = session[:username]
    render(:action => "index")
  end
  
  def new_message
    if (params[:message] && params[:message] != "")
      msg = Message.new
      msg.message = params[:message]
      msg.user_id = session[:usrid]
      msg.room_id = session[:roomid]
      msg.save
      
      if (params[:username] != session[:username])
        usr = User.find(session[:usrid])
        usr.username = params[:username]
        usr.save
        session[:username] = params[:username]
      end
        
      Pusher['chatapp1'].trigger('new_message', {:message => params[:message].gsub("'","\\\\'"), :username => params[:username].gsub("'","\\\\'"), :roomid => session[:roomid]})
    end
    
    respond_to do |format|
      format.js {
        render(:text => "ok") 
      }
    end
  end
  
  def change_room
    if (params[:room])
      room = Room.where("name = ?", params[:room])
      if (room.length > 0)
        session[:roomid] = room.first.id
        msgs = Message.where("room_id = ?", session[:roomid]).order("id DESC").limit(10).reverse
        rows = []
        i = 0
        puts "LENGTH: #{msgs.length}"
        msgs.each do |record|
          rows[i] = [User.where("id = ?", record.user_id).first.username, record.message, record.created_at]
          i += 1
        end
        msgs = rows.to_xml
        respond_to do |format|
          format.js {
            render(:xml => msgs)
          }
        end
      else
        puts("Room length was: #{room.length}")
        render(:action => index)
      end
    else
      puts("Params was: #{params[:room]}")
      render(:action => index)
    end
  end
        
  
  
end
