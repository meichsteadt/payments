class SubscriptionsController < ApplicationController
  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update(subscription_params)
      success = @subscription.subscribed ? @subscription.subscribe(stripe_params) : @subscription.unsubscribe(stripe_params)
      if success
        @subscription.subscribed ? status = "subscribed" : status = "unsubscribed"
        if @subscription.product.stripe_id == "homelegance_kiosk"
          @subscription.create_kiosk_user
        end
        flash[:notice] = "You were successfully #{status}"
        redirect_to '/'
      else
        redirect_to '/'
      end
    else
      flash[:notice] = "Something went wrong"
      redirect_to '/'
    end
  end

private
  def subscription_params
    params.require(:subscription).permit(:user_id, :product_id, :subscribed)
  end

  def stripe_params
    params.permit(:stripeToken, :stripeTokenType, :stripeEmail)
  end
end
