module FoodTypeHelper
  def formatted_serving_recomendation(value)
    return '-' if value.min == 0 && value.max == 0
    return 'unlimited' if value.min == 0 && value.max == Float::INFINITY
    return "up to #{value.max}" if value.min == 0
    return "at least #{value.min}" if value.max == Float::INFINITY
    "#{value.min} - #{value.max}"
  end
end
