require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "/" do
  before do
    get "/"
  end

  it "responds OK" do
    assert last_response.ok?, "Wasn't OK!"
  end
end
