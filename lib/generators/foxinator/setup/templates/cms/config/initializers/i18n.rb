begin
  unless (cms_locales = ::Comfy::Cms::Site.pluck(:locale)).any?
    cms_locales = [I18n.default_locale]
  end
rescue
  cms_locales = [I18n.default_locale]
end

Rails.application.config.i18n.available_locales = cms_locales