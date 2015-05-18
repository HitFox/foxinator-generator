require 'rails/generators/active_record'

module Foxinator
  module Generators
    class FeatureSpecGenerator < Rails::Generators::NamedBase
      
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

      def generate_controller
        template 'crud_spec.rb', "spec/features/admin/#{file_name.pluralize}_crud_spec.rb"
      end
    end
  end
end
