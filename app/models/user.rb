class User < ApplicationRecord
  has_many :active_claps , class_name: 'Clap', foreign_key: :from_user_id, dependent: :destroy
  has_many :passive_claps, class_name: 'Clap', foreign_key: :to_user_id  , dependent: :destroy

  has_many :users_of_received_claps_from, through: :passive_claps, source: :from_user
  has_many :users_of_sending_claps_to   , through: :active_claps , source: :to_user

  has_many :subscriptions, dependent: :destroy

  def to_param
    self.nickname
  end

  def clap(user)
    Clap.create(from_user_id: self.id, to_user_id: user&.id)
    # clapメソッドで web_push_to を呼ぶ処理を追加
    self.web_push_to(self, user)
  end

  def tweet(text)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['API_KEY']
      config.consumer_secret     = ENV['API_SECRET']
      config.access_token        = token
      config.access_token_secret = secret
    end
    client.update(text)
  end

  def web_push_to(from_user, to_user)
    message = {
        title: 'Pachipachi からメッセージ',
        body: "#{from_user.name}さんから ぱちぱち が届きました！",
        icon: ActionController::Base.helpers.asset_path('icons/icon-192x192.png'),
        tag: Time.now.to_i
    }
    subscriptions =  Subscription.where(user: to_user)
    subscriptions.each do |subscription|
      begin
        Webpush.payload_send(
            message: JSON.generate(message),
            endpoint: subscription.endpoint,
            p256dh: subscription.p256dh,
            auth: subscription.auth,
            vapid: {
                subject: "mailto:#{ENV['WEB_PUSH_VAPID_MAIL']}",
                public_key: ENV['WEB_PUSH_VAPID_PUBLIC_KEY'],
                private_key: ENV['WEB_PUSH_VAPID_PRIVATE_KEY'],
                expiration: 12 * 60 * 60
            }
        )
      rescue Webpush::InvalidSubscription => e
        logger.error e
        subscription.destroy
      end
    end
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def self.find_or_create_with_omniauth(auth, remember_token)
    provider = auth['provider']
    uid      = auth['uid']

    user = User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name       = auth['info']['name']
      user.nickname   = auth['info']['nickname']
      user.image_url  = auth['info']['image']
      user.token      = auth['credentials']['token']
      user.secret     = auth['credentials']['secret']
    end

    user.update!(remember_token: encrypt(remember_token))
  end
end
