module PetsHelper

  def pet_type_options(selected = nil)
    options = Pet::TYPES.map { |type| [I18n.t("pets.#{type.downcase}"), type] }
    options_for_select options, selected
  end

  def pet_gender_options(selected = nil)
    options = Pet::GENDERS.map { |gender| [I18n.t("pets.#{gender}"), gender] }
    options_for_select options, selected
  end

  def boolean_options(selected = nil)
    options_for_select [[I18n.t("shared.yes_word"), true], [I18n.t("shared.no_word"), false]], selected
  end

end
