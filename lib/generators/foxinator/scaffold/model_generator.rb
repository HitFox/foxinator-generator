require 'rails/generators/active_record'

module Foxinator
  module Generators
    module Scaffold
      class ModelGenerator < Rails::Generators::NamedBase
        
        include Rails::Generators::Migration
              
        attr_accessor :model_attrs
        
        source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
        
        argument :model_args, type: :array, default: [], banner: 'attribute:type'
        
        def initialize(*args, &block)
          super
          @model_attrs = []
          model_args.each do |arg|
            next unless arg.include?(':')
            @model_attrs << Rails::Generators::GeneratedAttribute.new(*arg.split(':')) 
          end
        end
        
        def self.next_migration_number(dirname)
          ActiveRecord::Generators::Base.next_migration_number(dirname)
        end

        def create_model
          migration_template 'migration.rb', "db/migrate/create_#{file_name.pluralize}.rb"
          template 'model.rb', "app/models/#{file_name.singularize}.rb"
        end
      end
    end
  end
end
