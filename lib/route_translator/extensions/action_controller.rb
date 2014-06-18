require 'action_controller'

module ActionController
  class Base
    around_filter :set_locale_from_domain, :set_locale_from_url 

    def set_locale_from_url(&block)
      I18n.with_locale params[RouteTranslator.locale_param_key], &block
    end
    
    def set_locale_from_domain
      I18n.locale = extract_locale_from_tld || I18n.default_locale
    end
    
    # Get locale from top-level domain or return nil if such locale is not available
    # You have to put something like:
    #   127.0.0.1 application.com
    #   127.0.0.1 application.it
    #   127.0.0.1 application.pl
    # in your /etc/hosts file to try this out locally
    def extract_locale_from_tld
      parsed_locale = request.host.split('.').last
      I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
    end
  end
end
