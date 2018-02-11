require 'securerandom'

class Subscription < ApplicationRecord
  belongs_to :product
  belongs_to :user

  def get_price
    subscription = Stripe::Plan.retrieve(self.product.stripe_id)
    return subscription["amount"]
  end

  def get_interval
    subscription = Stripe::Plan.retrieve(self.product.stripe_id)
    subscription['interval']
  end

  def subscribe(stripe_params)
    subscription = Stripe::Subscription.create({
      customer: self.user.stripe_customer_id,
      items: [{plan: self.product.stripe_id}],
    })
    rescue Stripe::InvalidRequestError => e
      User.find_by_email(stripe_params["stripeEmail"]).update_stripe_token(stripe_params["stripeToken"])
      self.subscribe(stripe_params)
  end

  def unsubscribe(stripe_params)
    customer = Stripe::Customer.retrieve(self.user.stripe_customer_id)
    customer["subscriptions"]["data"].each do |subscription|
      if subscription["plan"]["id"] == self.product.stripe_id
        subscription = Stripe::Subscription.retrieve(subscription["id"])
        subscription.delete
      end
    end
  end

  def create_kiosk_user
    user = self.user
    unless self.find_kiosk_user
      random_string = SecureRandom.hex(5)
      RestClient.post('https://homelegance-kiosk.herokuapp.com/users', {login: user.email, password: random_string}, headers={key: Base64.encode64(ENV['KIOSK_KEY']), secret: Base64.encode64(ENV['KIOSK_SECRET'])})
    else
      return "User already exists"
    end
  end

  def find_kiosk_user
    # RestClient.get('https://homelegance-kiosk.herokuapp.com/')
    users = JSON.parse(RestClient.get('http://localhost:3001/users.json').to_s)
    users.map {|e| e["login"]}.include?(self.user.email) ? true : false
  end
end
