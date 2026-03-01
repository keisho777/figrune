module FiguresHelper
  def display_total_price(figure)
    total_price = number_to_currency(figure.total_price, unit: "¥", format: "%u%n")
    css_class = figure.paid? ? "text-xl font-bold line-through" : "text-xl font-bold"

    content_tag(:span, total_price, class: css_class)
  end

  def release_label(figure)
    if figure.release_month < Date.current.beginning_of_month
      t(".released")
    else
      t(".upcoming")
    end
  end

  # XSS対策
  def safe_back_path(path)
    # pathが空、または JavaScript: で始まるような怪しい文字列ならホーム画面へ
    return home_path if path.blank? || path.start_with?("javascript:")

    # 自分のサイトのURL（絶対URL）なら許可してそのまま返す
    # request.base_url はドメイン部分を取得する
    if path.start_with?(request.base_url)
      return path
    end

    # 相対パス（/から始まる）なら許可
    if path.start_with?("/") && !path.start_with?("//")
      return path
    end

    # それ以外はホーム画面へ
    home_path
  end
end
