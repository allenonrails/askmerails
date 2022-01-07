require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  EMAIL_REGEX = /\A[a-z\d_+.\-]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  USERNAME_REGEX = /\A@[a-zA-Z0-9_]+\z/i

  has_many :questions  

  attr_accessor :password

  validates :username, format: { with: USERNAME_REGEX }, length: { maximum: 20 }, presence: true, uniqueness: true
  validates :email, format: { with: EMAIL_REGEX }, presence: true, uniqueness: true
  validates :description, length: { maximum: 255 }
  validates :password, presence: true, on: :create, confirmation: true, length: { minimum: 6 }

  validate :password_lower_case
  validate :password_uppercase
  validate :password_special_char
  validate :password_contains_number
  
  before_validation :to_lower_case

  before_save :encrypt_password

  def password_uppercase
    return if !!password.match(/\p{Upper}/)
    errors.add :password, ' must contain at least 1 uppercase '
  end

  def password_lower_case
    return if !!password.match(/\p{Lower}/)
    errors.add :password, ' must contain at least 1 lowercase '
  end

  def password_special_char
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return if password =~ regex
    errors.add :password, ' must contain special character'
  end

  def password_contains_number
    return if password.count("0-9") > 0
    errors.add :password, ' must contain at least one number'
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          self.password, self.password_salt,
          ITERATIONS,
          DIGEST.length, DIGEST
        )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = User.find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, user.password_salt,
          ITERATIONS, DIGEST.length, DIGEST
        )
      )
      user
    else
      nil
    end
  end

  def to_lower_case
    self.username&.strip!&.downcase!
    self.email&.strip!&.downcase!
  end
end   
