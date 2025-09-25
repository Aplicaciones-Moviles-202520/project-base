# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  if Rails.env.development? || Rails.env.test?
    allow do
      origins ENV.fetch("FRONTEND_ORIGIN", "http://localhost:3000")
      resource "*",
               headers: :any,
               methods: %i[get post put patch delete options head],
               credentials: true
    end
  else
    # Producción / staging
    allowed_origins = ENV.fetch("FRONTEND_ORIGIN", "").split(",")

    if allowed_origins.any?
      allow do
        origins(*allowed_origins)
        resource "*",
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end
  end
end
