module ApplicationHelper
  def form_error_classes(errors)
    if errors.any?
      'has-error has-feedback'
    else
      ''
    end
  end
end
