class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :encryptable, :lockable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid

  has_many  :accounts
  has_many  :transactions, :through=>:accounts

  def self.find_for_weibo_oauth (auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(provider:auth.provider, uid:auth.uid)
    end
    user
  end

end
