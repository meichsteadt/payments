class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      @user = resource
      customer = Stripe::Customer.create(email: @user.email)
      @user.update(stripe_customer_id: customer["id"])
      @user.products.push(Product.find_by_name("Homelegance Kiosk"))
      @user.products.push(Product.find_by_stripe_id("web_design_regular"))
    end
  end
end
