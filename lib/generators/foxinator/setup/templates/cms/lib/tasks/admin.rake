namespace :admins do
  desc 'Updates permissions from controllers and actions'
  task permit: [:environment, :create] do
    Settings.reload!
  end
  
  desc 'Create super admin'
  task create: :environment do
    Admin.first_or_create do |admin|
      admin.email = 'admin@example.com'
      admin.password = 'password'
    end
  end

  task setup: ['admins:create', 'admins:permit']
end
