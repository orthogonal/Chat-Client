class ApplicationController < ActionController::Base
  protect_from_forgery
    Pusher.app_id = '24871'
    Pusher.key = '0d22bb6090acca83850d'
    Pusher.secret = 'ce5dfa8c2212d4b2c952'
end
