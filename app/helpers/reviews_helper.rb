module ReviewsHelper
  def typo_helper(comparison_result)
    ["<b>Опечатка:</b> #{comparison_result[:input]}",
     "<b>Оригинал:</b> #{comparison_result[:original]}",
     "<b>Перевод:</b> #{comparison_result[:translate]}"].join("<br/>").html_safe
  end
end
