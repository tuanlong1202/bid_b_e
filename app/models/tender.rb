class Tender < ApplicationRecord
    validates :description, presence: true

    belongs_to :bid
    belongs_to :user
end
