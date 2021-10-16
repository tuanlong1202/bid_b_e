class MessagesController < ApplicationController

    before_action :authorize

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    # added rescue_from
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # GET /messages
    def index
      messages = Message.all
      render json: messages
    end

    # GET /inbox
    def inbox
      messages = Message.all.select { |m| m.receiver == session[:user_id] }
      messages.sort {|a,b| b.created_at <=> a.created_at}
      render json: messages
    end

    # GET /outbox
    def outbox
      messages = Message.all.select { |m| m.sender == session[:user_id] }
      messages.sort {|a,b| b.created_at <=> a.created_at}
      render json: messages
    end
  
    # GET /messages/:id
    def show
      message = find_message
      render json: message
    end
  
    # POST /messages
    def create
      message = Message.create!(message_params)
      render json: message, status: :created
    end
  
    # PATCH /messages/:id
    def update
        message = find_message
        message.update!(message_params)
        render json: message
    end
    
    # DELETE /bids/:id
    def destroy
        message = find_message
        message.destroy
        head :no_content
    end
    
    private
  
    def find_message
        Message.find(params[:id])
    end
    
    def render_not_found_response
      render json: { errors: ["Message not found"] }, status: :not_found
    end
  
    def message_params
      params.permit(:subject, :memo, :sender, :receiver, :unread)
    end

    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def authorize
      return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
  
end
