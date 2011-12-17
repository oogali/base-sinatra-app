require 'rubygems'
require 'active_record'

module AppName
  module Model
    class Table < ActiveRecord::Base
    end

    class Users < ActiveRecord::Base
      def self.authenticate(username, password)
        where(:username => username, :passwd => password).first
      end
    end
  end
end
