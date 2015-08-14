# name: google-auth-custom-callback
# about: 
# version: 0.1
# authors: 
# url: 

PLUGIN_NAME ||= "google_auth_custom_callback".freeze


after_initialize do


  module ::GoogleAuthCustomCallback
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace GoogleAuthCustomCallback
    end
  end

  Users::OmniauthCallbacksController.class_eval do
    def complete
      auth = request.env["omniauth.auth"]
      auth[:session] = session

      authenticator = self.class.find_authenticator(params[:provider])

      @auth_result = authenticator.after_authenticate(auth)

      if @auth_result.failed?
        flash[:error] = @auth_result.failed_reason.html_safe
        return render('failure')
      else
        @auth_result.authenticator_name = authenticator.name
        complete_response_data
        render "/plugins/google-auth-custom-callback/app/views/google_auth_custom_callback/complete"
      end
    end
  end


  
end
