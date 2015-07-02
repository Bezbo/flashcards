module ApplicationHelper
  def typo_helper(card, comparison, review_params)
    if comparison[:typos_count] == 0
      flash[:success] = "Абсолютно!"
    else
      flash[:success] =
        ["Опечатка: #{review_params[:user_input]}",
         "Оригинал: #{card.original_text}",
         "Перевод: #{card.translated_text}"].join("<br/>").html_safe
    end
  end
end
