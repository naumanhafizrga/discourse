# name: fake-api
# about: 
# version: 0.1
# authors: 
# url: 

PLUGIN_NAME ||= "fake_api".freeze


after_initialize do


  module ::FakeApi
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace FakeApi
    end
  end

  Auth::DefaultCurrentUserProvider.class_eval do
    def is_api?
      true
    end
  end


  
end
