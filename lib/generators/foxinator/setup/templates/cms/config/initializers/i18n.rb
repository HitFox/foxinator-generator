begin
  unless (cms_locales = ::Comfy::Cms::Site.pluck(:locale)).any?
    cms_locales = [I18n.default_locale]
  end
rescue
  cms_locales = [I18n.default_locale]
end

# Set your locale!
# Rails.application.config.i18n.default_locale = (Rails.env.test?) ? :en : :de
Rails.application.config.i18n.available_locales = cms_locales
