require "generators/foxinator"
require "find"

module Foxinator
  module Generators
    class SetupGenerator < Base
      include Rails::Generators::Migration
      
      def initialize(*args, &block)
        super
        # Build base controller and admin area
        generate("devise:install")
        generate("devise", "admin")
        generate(:migration, "AddStateToAdmin state:string:index")

        source_path = "cms/app/controllers/admin/"
        destination_path = "app/controllers/admin/"

        copy_file(source_path + "admins_controller.rb", destination_path + "admins_controller.rb")
        copy_file(source_path + "base_controller.rb", destination_path + "base_controller.rb")

        if ask("Do you want to install cms?").downcase.include?("y")

          generate("comfy:cms")
          say "queueing up cms..."
          paths = ["cms/"]

          use_permissions = ask("Do you want roles and permissions?").downcase.include?("y")
          if use_permissions
            say "queueing up roles and permissions..."
            generate(:migration, "CreateRoles identifier:string:index name:string created_at:datetime updated_at:datetime")
            generate(:migration, "CreatePermissions controller:string:index action:string:index created_at:datetime updated_at:datetime")
            generate(:migration, "AddRoleIdToAdmin role_id:integer")
            generate(:migration, "CreateJoinTablePermissionRole permissions:index roles:index")
            generate(:migration, "CreateJoinTableAdminPermission admins:index permissions:index")
            paths << "roles_and_permissions/"
          end

          use_comments = ask("Do you want comments?").downcase.include?("y")
          if use_comments
            say "queueing up comments..."
            generate(:migration, "CreateComments admin:references commentable:references{polymorphic} message:string created_at:datetime updated_at:datetime")
            generate(:migration, "CreateJoinTableAdminsComments admins:index comments:index")
            paths << "comments/"
          end

          #generating files for all selected folders
          say "generating all folders..."

          # Routes
          config = {comments: use_comments, permissions: use_permissions}
          File.delete("config/routes.rb")
          template("routes.rb.tt", "config/routes.rb", config)

          paths.each do |folder|

            Find.find(find_in_source_paths(folder)).to_a.each do |source|
              name = source.split("/").last
              if name.include?(".")
                destination_file = source.split(folder, 2).last
                
                if name[-2..-1] == "tt"
                  # say "copying: #{source} to #{destination_file[0..-4]}"
                  File.delete(destination_file[0..-4]) if File.exist?(destination_file[0..-4])
                  template(source, destination_file[0..-4], config)
                else
                  # say "copying: #{source} to #{destination_file}"
                  File.delete(destination_file) if File.exist?(destination_file)
                  copy_file(source, destination_file)
                end
              end
            end
          end
        end

        say "The best app template ever has been generated."
      end
    end
  end
end
