require 'rails/generators/active_record'

module Foxinator
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      
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

      def generate_controller
        template 'controller.rb', "app/controllers/admin/#{file_name.pluralize}_controller.rb"
      end
      
      def generate_views
        template 'views/_form.html.haml', "app/views/admin/#{file_name.pluralize}/_form.html.haml"
        template 'views/_right_column_after.html.haml', "app/views/admin/#{file_name.pluralize}/_right_column_after.html.haml"
        template 'views/_heading.html.haml', "app/views/admin/#{file_name.pluralize}/_heading.html.haml"
        template 'views/_show.html.haml', "app/views/admin/#{file_name.pluralize}/_show.html.haml"
        template 'views/_table_head.html.haml', "app/views/admin/#{file_name.pluralize}/_table_head.html.haml"
        template 'views/_file_name.html.haml', "app/views/admin/#{file_name.pluralize}/_#{file_name}.html.haml"
      end
      
      def generate_route
        admin_namespace  = "namespace\ :admin\ do\n"
        in_root do
          inject_into_file "config/routes.rb", "      resources :#{file_name.pluralize}\n", { after: admin_namespace, verbose: false, force: true }
        end
      end
      
      def generate_navigation_link
        partial_path = 'app/views/comfy/admin/cms/partials/_navigation_inner.html.haml'
        unless File.exist?(File.join(destination_root, partial_path))
          create_file partial_path
        end
        append_file partial_path do
          "\n%li= active_link_to '#{class_name.pluralize}', admin_#{file_name.pluralize}_path\n"
        end
      end
    end
  end
end
