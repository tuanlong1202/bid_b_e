class Message < ApplicationRecord
    validates :subject, presence: true
    validates :memo, presence: true
end
