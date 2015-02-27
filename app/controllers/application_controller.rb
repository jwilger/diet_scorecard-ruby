class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :set_time_zone

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
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
      private *names.map { |name| "#{name}=" }
    end
  end

  extend HasTemplateAttrs

  service(:current_user) { TemporaryUserHack::User.new }

  # TODO: This is a temporary hack to allow the *concept* of a logged in user to
  # be built in from the beginning without actually have to deal with any
  # authentication yet.
  module TemporaryUserHack
    class User
      def time_zone
        'PST8PDT'
      end
    end
  end
end
