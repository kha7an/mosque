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

  config.authenticate_with do
    username = ENV["AVO_ADMIN_USER"].to_s
    password = ENV["AVO_ADMIN_PASSWORD"].to_s

    authenticate_or_request_with_http_basic("Avo") do |u, p|
      next false if username.blank? || password.blank?

      ActiveSupport::SecurityUtils.secure_compare(u, username) &
        ActiveSupport::SecurityUtils.secure_compare(p, password)
    end
  end

  config.authorization_client = nil
  config.explicit_authorization = true
  config.click_row_to_view_record = true
end
