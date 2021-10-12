class TendersController < ApplicationController

    before_action :authorize
    skip_before_action :authorize, only: [:index]

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    # added rescue_from
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # GET /tenders
    def index
      if params[:bid_id]
        bid = Bid.find(params[:bid_id])
        tenders = bid.tenders
      else
        tenders = Tender.all
      end
      render json: tenders, include: :bid
    end
  
    # GET /tenders/:id
    def show
      tender = find_tender
      render json: tender, include: :bid
    end
  
    # POST /tenders
    def create
      tender = Tender.create!(tender_params)
      render json: tender, status: :created
    end
  
    # PATCH /tenders/:id
    def update
        tender = find_tender
        tender.update!(tender_params)
        render json: tender
    end
    
    # DELETE /tenders/:id
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
