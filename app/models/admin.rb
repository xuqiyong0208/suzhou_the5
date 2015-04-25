require 'digest'

class Admin < Sequel::Model

  set_dataset :tb_admin

  set_allowed_columns :username, :email, :password, :is_root


  class << self

    def encrypt(string)
      salt1 = 'SuZhouThe5BasicSalt'
      salt2 = Sinarey.secret.to_s
      baseString = "#{salt1}#{string}#{salt2}"
      Digest::SHA2.hexdigest(baseString)
    end

    def authenticate(account,password)
      return if account.nil? or password.nil?

      if email_regex_match?(account)
        user = where(email:account,password:password).first
      else
        user = where(username:account,password:password).first
      end
      return user
    end

    def username_regex_match?(username)
      return false if username.blank?
      username == username.match(/\A[a-zA-Z][a-zA-Z0-9_]*\z/).to_s
    end

    def email_regex_match?(email)
      return false if email.blank?
      email == email.match(/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/).to_s
    end
    
    def generate_token(user,client_ip)
      secrue = generate_secrue(user,client_ip)
      "#{user.id}|#{secrue}"
    end

    def generate_secrue(user,client_ip)
      Digest::SHA2.hexdigest("#{user.id}|#{client_ip}|#{user.password.first(6)}|#{Sinarey.secret}")
    end

  end

end
