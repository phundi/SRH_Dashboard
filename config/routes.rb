Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'home/index'

  get 'report/index'
  get 'user/index'
	get 'report/srh_report'
	get 'report/ajax_srh_report'
	get 'report/ajax_ou_users'
	get 'report/download_excel'
	post 'report/download_excel'

	get 'report/user_audit_report'
	get 'report/download_user_audit_excel'
	post 'report/download_user_audit_excel'
	get 'report/ajax_user_audit_report'

	get 'report/travellers_report'
	get 'report/ajax_travellers_report'
	get 'report/download_travellers_excel'
	post 'report/download_travellers_excel'


	get "user/index"
  get "user/edit"
  get "user/new"
  post "user/edit"
  get "user/delete"

  get "user/change_password"
  post "user/change_password"

  post "user/new"
  get "user/view"
  get "/logout" => 'user#logout'
  get "/login" => "user#login"
  post "/login" => "user#login"

  get "user/roles"
  get "user/permissions"

  get "user/new_role"
  get "user/edit_role"
  get "user/edit_role"
  post "user/edit_role"
  post "user/new_role"
  get "user/delete_role"
  get "user/view_role"
end
