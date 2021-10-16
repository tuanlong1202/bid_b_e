class BidsController < ApplicationController

    before_action :authorize
    skip_before_action :authorize, only: [:index]
  
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    # added rescue_from
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
    # GET /bids
    def index
      bids = Bid.all.sort {|a,b| b.created_at <=> a.created_at}
      render json: bids, include: :user
    end
  
    # POST /bids
    def create
      bid = Bid.new(bid_params)
        bid.user_id = session[:user_id]
        if bid.valid?
          bid.save
          render json: bid,include: :user, status: :created
        else
          render json: { errors: bid.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    # GET /bids/:id
    def show
      bid = find_bid
      render json: bid, include: [:tenders, :user]
    end
  
    # PATCH /bids/:id
    def update
      bid = find_bid
      if bid.user_id == session[:user_id]
        bid.update!(bid_params)
      end
      render json: bid
    end
  
    # DELETE /bids/:id
    def destroy
      bid = find_bid
      if bid.user_id == session[:user_id]
        bid.destroy
      end
      head :no_content
    end
  
    private
  
    def find_bid
      Bid.find(params[:id])
    end
  
    def bid_params
      params.require(:bid).permit(:subject, :image, :price, :description, :last_price, :end_session)
    end
  
    def render_not_found_response
      render json: { errors: ["Bid not found"] }, status: :not_found
    end
  
    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
  
    def authorize
      return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
    
  end
