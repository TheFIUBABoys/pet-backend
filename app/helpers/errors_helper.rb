module ErrorsHelper
  # Possible types: success, info, warning, danger
  def error_messages!(resource, type = "warning")
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-#{type} alert-dismissible" role="alert">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      <strong>#{sentence}</strong>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
