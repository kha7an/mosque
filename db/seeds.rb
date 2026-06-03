def seed_admin_user
  login = ENV["ADMIN_LOGIN"].presence
  password = ENV["ADMIN_PASSWORD"].presence
  return unless login.present? && password.present?

  user = User.find_or_initialize_by(login: login.strip.downcase)
  user.password = password
  user.save!
  puts "Admin user: #{user.login}"
end

seed_admin_user
