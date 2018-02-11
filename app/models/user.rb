class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :products, through: :subscriptions

  def update_stripe_token(stripe_token)
    cu = Stripe::Customer.retrieve(self.stripe_customer_id)
    cu.source = stripe_token
    cu.save
  end

  def has_stripe_token?
    cu = Stripe::Customer.retrieve(self.stripe_customer_id)
    cu["default_source"]
  end
end
