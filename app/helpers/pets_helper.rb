module PetsHelper

	def pet_type_options
		options_for_select Pet::TYPES
	end

	def pet_gender_options
		options_for_select Pet::GENDERS
	end

end
