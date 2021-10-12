class User < ApplicationRecord

    has_secure_password

    validates :user_name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true

    has_many :bids, dependent: :destroy
    has_many :tenders, dependent: :destroy
end
