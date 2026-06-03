Avo.configure do |config|
  config.root_path = "/avo"
  config.home_path = -> {
    resource = Avo.resource_manager.all.min_by(&:model_key)
    resources_path(resource: resource)
  }
  config.app_name = -> { "Перейти на сайт" }

  config.set_context do
    # Return a context object that gets evaluated within Avo::ApplicationController
  end

  config.current_user_method do
    Current.user
  end
  config.sign_out_path_name = :session_path

  config.authorization_client = nil
  config.explicit_authorization = true
  config.click_row_to_view_record = true
end
