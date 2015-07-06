class NotificationsMailer < ActionMailer::Base
  def pending_cards(user)
    @review_url = new_review_url
    mail(to: user.email, subject: "Повтори карточки!")
  end
end
