class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def enum_i18n(enum_name)
    enum_name = enum_name.to_s

    return unless self.class.defined_enums.key?(enum_name)

    enum_key = public_send(enum_name)
    return if enum_key.blank?

    I18n.t(
      "activerecord.attributes.#{self.class.model_name.i18n_key}.#{enum_name.pluralize}.#{enum_key}",
      default: enum_key.humanize
    )
  end
end
