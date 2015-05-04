namespace :admins do
  desc 'Updates permissions from controllers and actions'
  task permit: [:environment, :create] do
    Settings.reload!
    Permission.sync_and_permit_admins!  
  end
  
  desc 'Create super admin'
  task create: :environment do
    role = Role.where(identifier: :super_admin, name: 'Super Admin').first_or_create
    role.admins.first_or_create do |admin|
      admin.email = 'admin@example.com'
      admin.password = 'password'
    end
  end

  task setup: ['admins:create', 'admins:permit']
end
