ImdbKnockoff::App.controllers :session do
  post :create, map: '/session' do
    # Note: This is ENTIRELY insecure
    if params[:username] == 'JackHoff' && params[:password] == "ih8b3n"
      session[:authenticated] = true

      redirect url(:movies, :new)
    else
      halt 403, "NOT AUTHORIZED"
    end
  end
end
