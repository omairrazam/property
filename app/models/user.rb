class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  enum role: %i(client admin dealer)

  #has_many :, :class_name => 'Transaction', :foreign_key => 'buyer_id'
  #has_many :sellings, :class_name => 'Transaction', :foreign_key => 'seller_id'

end
