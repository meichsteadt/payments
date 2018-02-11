class Product < ApplicationRecord
  has_many :subscriptions
  has_many :products, through: :subscriptions
end
