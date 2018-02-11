class ChargesController < ApplicationController
  def new
    @products = Product.all
  end

  def create
    # Amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    subscription = Stripe::Subscription.create({
        customer: customer.id,
        items: [{plan: 'premium'}],
    })


  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
