class Contact < ApplicationRecord
  validates :message, presence: true
    validates :email, presence: true
end
