class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update]
  skip_after_action :verify_authorized

  def index
    @chatroom = Chatroom.new
    @chatrooms = Chatroom.all
  end

  def new
    @connect = Connect.new
    if request.referrer.split("/").last == "chatrooms"
      flash[:notice] = nil
    end
    @chatroom = Chatroom.new
  end

  def edit
  end

  def create
    @chatroom = Chatroom.new#(chatroom_params)
    @chatroom.topic = params[:topic] # I don't really need this anymore because I put a form in the new view instead of the buttons. Turns out I do need this because 2 submit buttons will not work for an agree and disagree value.
    if_saved = @chatroom.save

    chatroom_obj = Chatroom.where(:topic => params[:topic])

    @connect = Connect.new
    @connect.article = params[:article]
    @connect.user_id = current_user.id
    @connect.chatroom_id = chatroom_obj[0].id
    @connect.save

    topic = params[:topic]

    if if_saved
      respond_to do |format|
        format.html { redirect_to @chatroom }
        format.js
      end
    elsif @chatroom.topic == topic #@connect.save && @connect.topic == chatroom_obj[0].topic
      respond_to do |format|
        format.html { redirect_to chatroom_path(chatroom_obj[0].slug) }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["To better Engauge you, please select from the options below and enter article link."]}
        format.html { redirect_to new_chatroom_path }
        format.js { render template: 'chatrooms/chatroom_error.js.erb'}
      end
    end
  end

  def update
    chatroom.update(chatroom_params)
    redirect_to chatroom
  end

  def show
    @object = LinkThumbnailer.generate('http://www.smh.com.au/federal-politics/political-opinion/north-korean-threats-will-leave-alliance-countries-little-choice-20170423-gvqpxh.html')

    @message = Message.new
    chatroom = Chatroom.find_by(slug: params[:slug])

    @connect = Connect.where("chatroom_id = ? AND user_id = ?", chatroom.id, current_user)
    puts "/////////"
    puts @connect.inspect
    puts "////////"
    @user = current_user
  end

  private

    def set_chatroom
      @chatroom = Chatroom.find_by(slug: params[:slug])
    end

    def chatroom_params
      params.require(:chatroom).permit(:topic)
    end
end
