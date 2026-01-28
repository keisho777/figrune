module FiguresHelper
  def display_total_price(figure)
    total_price = number_to_currency(figure.total_price, unit: "¥", format: "%u%n")
    css_class = figure.paid? ? "text-xl font-bold line-through" : "text-xl font-bold"

    content_tag(:span, total_price, class: css_class)
  end
end
