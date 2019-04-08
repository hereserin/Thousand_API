Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://www.erin-e-marshall.com/ThousandApp'

    resource '*', headers: :any,
    methods: [:get, :post, :options, :head]
  end
end
