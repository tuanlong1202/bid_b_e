class TendersController < ApplicationController

    before_action :authorize
    skip_before_action :authorize, only: [:index]

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    # added rescue_from
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # GET /bids/:bid_id/tenders
    def index
      if params[:bid_id]
        bid = Bid.find(params[:bid_id])
        tenders = bid.tenders.all.sort {|a,b| b.price <=> a.price}
      else
        tenders = Tender.all.sort {|a,b| b.price <=> a.price}
      end
      render json: tenders, include: [:bid, :user]
    end
  
    # GET /bids/:bid_id/tenders/:id
    def show
      tender = find_tender
      render json: tender, include: [:bid, :user]
    end
  
    # POST /bids/:bid_id/tenders
    def create
      tender = Tender.new(tender_params)
      tender.bid_id = params[:bid_id]
      tender.user_id = session[:user_id]
      if tender.valid?
        tender.save
        render json: tender, status: :created
      else
        render json: { errors: tender.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # PATCH /bids/:bid_id/tenders/:id
    def update
        tender = find_tender
        tender.update!(tender_params)
        render json: tender
    end
    
    # DELETE /bids/:bid_id/tenders/:id
    def destroy
        tender = find_tender
        tender.destroy
        head :no_content
    end
    
    private

    def find_tender
        Tender.find(params[:id])
    end
  
    def render_not_found_response
      render json: { errors: ["Tender not found"] }, status: :not_found
    end
  
    def tender_params
      params.permit(:description, :price, :bid_id, :user_id)
    end

    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def authorize
      return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
  
end
