Rails.application.routes.draw do
  scope ':locale', defaults: { locale: I18n.default_locale.to_s } do
    
    devise_for :admins, path: '/admin', path_names: { sign_in: 'login', sign_out: 'logout' }

    concern :commentable do
      resources :comments, only: [:create, :destroy]
    end

    namespace :admin do
      resources :test_models, concerns: [:commentable]
      resource :account, only: [:edit, :update]

      resources :roles, except: :show, concerns: [:commentable] do |variable|
        patch :sync_and_permit, on: :collection
        patch :sync, on: :collection
      end
      

      resources :admins, concerns: [:commentable] do
        member do
          get :permissions

          Admin.state_machine.events.map(&:name).each do |event_name|
            patch event_name
          end
        end
      end

      resources :comments

      root 'dashboards#index'
    end

    comfy_route :cms_admin, path: 'admin/cms'
    comfy_route :cms, path: '/', sitemap: false
  end
  
  root to: 'comfy/cms/content#show'
end
