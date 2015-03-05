require 'active_record'
require 'bcrypt'
require 'will_paginate'

module AppName
  module Db
    class Object < ActiveRecord::Base
    end

    class User < ActiveRecord::Base
      validates :username,  presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1 }
      validates :name, presence: true, length: { minimum: 1 }

      def password
        @password ||= BCrypt::Password.new passwd
      end

      def password=(new_password)
        self.passwd = BCrypt::Password.create new_password, :cost => 6
      end

      def self.sso_login(auth)
        user = self.find_by_email(auth.info.email) || self.create(:email => auth.info.email, :passwd => 'GOOGLE APPS SSO', :name => auth.info.name)
      end

      def self.authenticate(username, user_passwd)
        # search for user, short circuit if not found
        user = self.find_by_username username
        return nil unless user

        # check password
        user.password == user_passwd ? user : nil
      end
    end
  end
end
