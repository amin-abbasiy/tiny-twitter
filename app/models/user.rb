require 'bcrypt'
class User < ApplicationRecord
    has_many :microposts, dependent: :destroy

    has_many :active_relationships, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy

    has_many :passive_relationship, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy

    has_many :following, through: :active_relationships, source: :followed
    
    has_many :followers, through: :passive_relationship, source: :follower

    attr_accessor :remember_token, :activation_token, :reset_token
    before_save {self.email = email.downcase}  #For Disable Case Sensetive
    before_create :create_activation_digest
    validates( :name, presence: true, length: { maximum: 50 } )
    VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates(:email, presence: true, length: {maximum: 255}, 
                                               format: {with: VALIDATE_EMAIL_REGEX},
                                               uniqueness: {case_sensitive: false} )
    # validates_presence_of (:name)
    has_secure_password
    validates( :password, presence: true ,length: {minimum: 5}, allow_nil: true)
# class << self
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    def User.new_token #can be define this shape self.new_token
        SecureRandom.urlsafe_base64
    end
# end
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    def authenticated?(attr, log_in_token)
       digest = send("#{attr}_digest")
       return false if digest.nil?
       BCrypt::Password.new(digest).is_password?(log_in_token)    
    end
    def forget
       update_attribute(:remember_digest, nil)        
    end
    
    def activate
        # update_attribute(:activated, true)
        # update_attribute(:activated_at, Time.zone.now)
        update_columns(activated: true, activated_at: Time.zone.now)
    end
    def send_activation_email
        UserMailer.accont_activation(self).deliver_now
    end
    def create_reset_token
        self.reset_token = User.new_token
        # update_attribute(:reset_digest, User.digest(reset_token))
        # update_attribute(:reset_send_at, Time.zone.now)
        update_columns(reset_digest: User.digest(reset_token), reset_send_at: Time.zone.now)
    end
    def email_reset_token
        UserMailer.password_reset(self).deliver_now
    end
    def feed
        following_ids = "SELECT followed_id FROM relationships
              WHERE  follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                         OR user_id = :user_id", user_id: self)                 
    #    Micropost.where("user_id IN (:following_ids) OR user_id = :user_id", 
    #                                 following_ids: following_ids, 
    #                                 user_id: id)
    end
    def follow(other_user)
       following << other_user
    end
    def unfollow(other_user)
       following.delete(other_user)
    end
    def following?(other_user)
       following.include?(other_user)
    end
    private
    def create_activation_digest
       self.activation_token = User.new_token
       self.activation_digest = User.digest(activation_token)  
    end

end
