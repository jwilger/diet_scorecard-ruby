class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  around_filter :set_time_zone

  def set_time_zone(&block)
    if user_signed_in?
      Time.use_zone(current_user.timezone, &block)
    else
      yield
    end
  end

  module HasServices
    def self.extended(klass)
      klass.include(InstanceMethods)
    end

    def service(name, &block)
      attr_writer name
      private "#{name}="

      define_method(name) do
        instance_variable_get("@#{name}") \
          || instance_variable_set("@#{name}", instance_eval(&block))
      end
    end

    module InstanceMethods
      def load_services(services = {})
        services.each do |name, instance|
          self.send("#{name}=", instance)
        end
      end
    end
  end

  extend HasServices

  module HasTemplateAttrs
    def template_attr(*names)
      attr_accessor *names
      helper_method *names
      private *names.map { |name| "#{name}=" }
    end
  end

  extend HasTemplateAttrs

  private

  def date_params_from(date)
    {:year => date.year, :month => date.month, :day => date.day}
  end
end
