module ReviewsHelper
  def typo_helper(comparison_result)
    ["<b><%= t('.typo') %>:</b> #{comparison_result[:input]}",
     "<b><%= t('original') %>:</b> #{comparison_result[:original]}",
     "<b><%= t('translate') %>:</b> #{comparison_result[:translate]}"].join("<br/>").html_safe
  end
end
