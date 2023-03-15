Airbrake.configure do |config|
  config.host = 'https://errbit.kapusons.it'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = 'c420582a55eedc7f36a46cbab301a512'

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end