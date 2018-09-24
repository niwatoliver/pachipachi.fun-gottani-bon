class SubscriptionsController < ApplicationController
  protect_from_forgery except: :create
  rescue_from Exception, with: :error_500 unless Rails.env.development?

  def create
    subscription = Subscription.find_or_create_by(
        endpoint: params[:subscription][:endpoint]
    ) do |subscription|
      subscription.user   = current_user
      subscription.p256dh =  params[:subscription][:keys][:p256dh]
      subscription.auth   = params[:subscription][:keys][:auth]
    end
    subscription.update(user: current_user)
    render json: {status: 'ok', code: 200, content: {}}
  end
  
  private
  def error_500(e = nil)
    logger.error e
    render json: {status: 'ng',
                  code: 500,
                  content: { message: '500 Internal Server Error' }
    }, status: 500
  end
end