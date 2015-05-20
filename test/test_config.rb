RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
Dir[File.expand_path(File.dirname(__FILE__) + "/../app/helpers/**/*.rb")].each(&method(:require))
require 'minitest/pride'

class MiniTest::Spec
  include Rack::Test::Methods

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  # You can use this method to custom specify a Rack app
  # you want rack-test to invoke:
  #
  #   app ImdbKnockoff::App
  #   app ImdbKnockoff::App.tap { |a| }
  #   app(ImdbKnockoff::App) do
  #     set :foo, :bar
  #   end
  #
  def app(app = nil, &blk)
    @app ||= block_given? ? app.instance_eval(&blk) : app
    @app ||= Padrino.application
  end
end
