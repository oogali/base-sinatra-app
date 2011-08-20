require 'rubygems'
require 'active_record'

module AppName
  module DBModel
    class CreateTable < ActiveRecord::Migration
      def self.up
        create_table :table do |t|
          t.index :id
        end
      end

      def self.down
        drop_table :table
      end
    end

    class Table < ActiveRecord::Base
    end
  end
end
