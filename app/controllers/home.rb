ImdbKnockoff::App.controllers :home do
  get :index, map: '/' do
    render 'index'
  end
end
