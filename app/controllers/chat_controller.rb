class ChatController < ApplicationController
  require 'pusher'
  
  @usrid = 0
  @username = "Guest"
  @roomid = 0
  
  def index
    ip = request.remote_ip
    usr = User.where("ip = ?", ip)
    if (usr.length > 0)
      @usrid = usr.first.id
      @username = usr.first.username
    else
      usr = User.new
      usr.ip = ip
      usr.username = "Guest"
      usr.save
      usr = User.where("ip = ?", ip)
      @usrid = usr.first.id
    end
    @msgs = Message.where("room_id = ?", @roomid).order("id DESC").limit(10).reverse
    @name = @username
    render(:action => "index")
  end
  
  def new_message
    puts "User ID: #{@usrid}"
    if (params[:message] && params[:message] != "")
      msg = Message.new
      msg.message = params[:message]
      msg.user_id = @usrid
      msg.room_id = @roomid
      msg.save
      
      if (params[:username] != @username)
        usr = User.find(@usrid)
        usr.username = params[:username]
        usr.save
        @username = params[:username]
      end
        
      Pusher['chatapp1'].trigger('new_message', {:message => params[:message], :username => params[:username]})
    end
    
    respond_to do |format|
      format.js {
        render(:text => "ok") 
      }
    end
  end
  
  def change_room
    puts "Parameter: #{params[:room]}"
    if (params[:room])
      room = Room.where("name = ?", params[:room])
      puts "Length: #{room.length}"
      if (room.length > 0)
        @roomid = room.first.id
        msgs = Message.where("room_id = ?", @roomid).order("id DESC").limit(10).reverse
        rows = []
        i = 0
        puts "LENGTH: #{msgs.length}"
        msgs.each do |record|
          puts("USER ID: #{record.user_id}")
          rows[i] = [User.where("id = ?", record.user_id).first.username, record.message, record.created_at]
          i += 1
        end
        msgs = rows.to_xml
        puts "STRING: #{msgs}"
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
