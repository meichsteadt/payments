class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      @user = resource
      customer = Stripe::Customer.create(email: @user.email)
      @user.update(stripe_customer_id: customer["id"])
      @user.products.push(Product.find_by_name("Homelegance Kiosk"))
    end
  end
end
