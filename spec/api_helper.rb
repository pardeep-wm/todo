module APIHelper
    def parse_json
      JSON.parse(response.body)
    end
  end
  
  RSpec.configure { |config| config.include APIHelper }