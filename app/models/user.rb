class User < ActiveRecord::Base
  attr_accessor :reset_token

  has_many :user_courses, dependent: :destroy
  has_many :user_lessons
  has_many :user_words, dependent: :destroy
  has_many :practices
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }
  validates :name, length: { maximum: 50 }, presence: true
  validates :email, length: { maximum: 100 }, presence: true,
                    format: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                    uniqueness: { case_sensitive: false }
  has_secure_password
  mount_uploader :image, PictureUploader
  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)/x.freeze
  validates :password, length: { within: 8..40 },
                       format: { with: PASSWORD_FORMAT }, allow_blank: false
  scope :order_name_user, -> { order(name: :ASC) }
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def authenticated?(_attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(user_id)
    following.find { |x| x[:id] == user_id }.present?
  end
end
