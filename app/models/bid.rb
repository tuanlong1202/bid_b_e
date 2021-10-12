class Bid < ApplicationRecord
    
    validates :subject, presence: true
    validates :image, presence: true
    validates :description, presence: true

    belongs_to :user
    has_many :tenders, dependent: :destroy
end
