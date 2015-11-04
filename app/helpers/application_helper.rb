module ApplicationHelper

  def date_picker_options
    { "class" => "form-control", "data-provide" => "datepicker", "data-date-format" => "yyyy-mm-dd" }
  end

end
