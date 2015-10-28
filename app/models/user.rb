class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :validatable, :authentication_keys => [:login]

  has_many :tweets

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :icon => "30x30>", }, :default_url => "/images/:style/default_image.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :username,
    :presence => true,
    :uniqueness => {
    :case_sensitive => false
    }

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
   conditions = warden_conditions.dup
   if login = conditions.delete(:login)
     where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
   else
     where(conditions.to_hash).first
   end
  end

end
