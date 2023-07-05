Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/1' } # Attenzione al numero del database se ci sono altre app sullo stesso server
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' } # Attenzione al numero del database se ci sono altre app sullo stesso server
end
