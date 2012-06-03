require 'active_record'
require 'bcrypt'
require 'will_paginate'

module AppName
  module Model
    class Object < ActiveRecord::Base
    end

    class User < ActiveRecord::Base
      def password
        @password ||= BCrypt::Password.new passwd
      end

      def password=(new_password)
        self.passwd = BCrypt::Password.create new_password, :cost => 6
      end

      def self.authenticate(username, user_passwd)
        user = self.find_by_username username
        user.password == user_passwd ? user : nil
      end
    end
  end
end
