require 'generators/foxinator'
# require 'rails/generators/migration'
# require 'rails/generators/generated_attribute'
require 'find'
# require 'pry'
module Foxinator
  module Generators
    class SetupGenerator < Base
      include Rails::Generators::Migration
      
      def generate_all
        # gem 'devise'
        # gem 'state_machine'
        # gem 'inherited_resources'
        # gem 'rails_config'
        
        # run "bundle install"

        # Build base controller and admin area

        generate("devise:install")
        generate("devise", "admin")
        generate(:migration, 'AddStateToAdmin state:string:index')

        source_path = "cms/app/controllers/admin/"
        destination_path = "app/controllers/admin/"

        copy_file(source_path + "admins_controller.rb", destination_path + "admins_controller.rb")
        copy_file(source_path + "base_controller.rb", destination_path + "base_controller.rb")

        if ask("Do you want to install cms?").downcase.include?("y")

          # gem 'comfortable_mexican_sofa', git: 'git@github.com:HitFox/comfortable-mexican-sofa.git'
          # run "bundle install"
          generate("comfy:cms")
          say "queueing up cms..."
          destination_path = "app/views/admin/admins/"
          paths = ["cms/"]

          use_permissions = ask("Do you want roles and permissions?").downcase.include?("y")
          if use_permissions
            say "queueing up roles and permissions..."
            generate(:migration, 'CreateRoles identifier:string:index name:string created_at:datetime updated_at:datetime')
            generate(:migration, 'CreatePermissions controller:string:index action:string:index created_at:datetime updated_at:datetime')
            generate(:migration, 'AddRoleIdToAdmin role_id:integer')
            generate(:migration, 'CreateJoinTablePermissionRole permissions:index roles:index')
            generate(:migration, 'CreateJoinTableAdminPermission admins:index permissions:index')
            paths << "roles_and_permissions/"
          end

          use_comments = ask("Do you want comments?").downcase.include?("y")
          if use_comments
            say "queueing up comments..."
            paths << "comments/"
          end

          #generating files for all selected folders
          say "generating all folders..."

          # Routes
          config = {comments: use_comments, permissions: use_permissions}
          # File.delete("config/routes.rb")
          template("routes.rb.tt", "config/routes.rb", config)

          paths.each do |folder|
            puts find_in_source_paths(folder)
            # binding.pry
            # puts Find.class
            # puts Find.methods.sort
            Find.find(find_in_source_paths(folder)).to_a.each do |source|
              name = source.split("/").last
              if name.include?(".")
                destination_file = source.split(folder).last
                puts destination_file
                
                if name[-2..-1] == "tt"
                  say "copying: #{source} to #{destination_file[0..-4]}"
                  # File.delete(destination_file[0..-4]) if File.exist?(destination_file[0..-4])
                  template(source, destination_file[0..-4], config)
                else
                  say "copying: #{source} to #{destination_file}"
                  # File.delete(destination_file) if File.exist?(destination_file)
                  copy_file(source, destination_file)
                end
              end
            end
          end
        end

        say 'The best app template ever has been generated.'
      end
    end
  end
end
