module Admin::TeaProductSubmissionsHelper

  def diff_field(label, old, new)
    return if normalize(old) == normalize(new)

    content_tag(:div) do
      concat content_tag(:p, label, class: "text-sm text-gray-500 mb-1")

      concat(
        content_tag(:div, class: "grid grid-cols-1 sm:grid-cols-2 gap-4") do
          concat content_tag(:div, class: "bg-gray-100 p-2 rounded text-sm") {
            old.presence || "未設定"
          }
          concat content_tag(:div, class: "bg-yellow-100 p-2 rounded text-sm font-semibold") {
            new.presence || "未設定"
          }
        end
      )
    end
  end

  def diff_flavors(previous, current)
    old = previous.flavors.map { |f|
      "#{f.flavor_category&.name}-#{f.name}"
    }.sort

    new = current.flavors.map { |f|
      "#{f.flavor_category&.name}-#{f.name}"
    }.sort

    return if old == new

    content_tag(:div) do
      concat content_tag(:p, "フレーバー", class: "text-sm text-gray-500 mb-1")

      concat(
        content_tag(:div, class: "grid grid-cols-1 sm:grid-cols-2 gap-4") do
          concat content_tag(:div, class: "bg-gray-100 p-2 rounded text-sm") {
            if old.present?
              safe_join(old.map { |f| content_tag(:div, f) })
            else
              "未設定"
            end
          }
          concat content_tag(:div, class: "bg-yellow-100 p-2 rounded text-sm font-semibold") {
            if new.present?
              safe_join(new.map { |f| content_tag(:div, f) })
            else
              "未設定"
            end
          }
        end
      )
    end
  end

  def diff_purchase_locations(previous, current)
    old = previous.purchase_locations.map { |l| "#{l.enum_i18n(:location_type)}-#{l.name}" }.sort
    new = current.purchase_locations.map { |l| "#{l.enum_i18n(:location_type)}-#{l.name}" }.sort

    return if old == new

    content_tag(:div) do
      concat content_tag(:p, "購入場所", class: "text-sm text-gray-500 mb-1")

      concat(
        content_tag(:div, class: "grid grid-cols-1 sm:grid-cols-2 gap-4") do
          concat content_tag(:div, class: "bg-gray-100 p-2 rounded text-sm") {
            if old.present?
              safe_join(old.map { |f| content_tag(:div, f) })
            else
              "未設定"
            end
          }
          concat content_tag(:div, class: "bg-yellow-100 p-2 rounded text-sm font-semibold") {
            if new.present?
              safe_join(new.map { |f| content_tag(:div, f) })
            else
              "未設定"
            end
          }
        end
      )
    end
  end

  def normalize(value)
    value.presence || ""
  end

end