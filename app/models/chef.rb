class Chef < ApplicationRecord
  validates :chefname, presence: true, length: { maximum: 30 }
  validates :email, presence: true
end
