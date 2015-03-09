module ApplicationHelper
  def form_error_classes(errors)
    if errors.any?
      'has-error has-feedback'
    else
      ''
    end
  end

  def render_flash_messages(obj)
    case obj
    when String
      obj
    else
      t(obj.delete('key'), obj.symbolize_keys)
    end
  end
end
