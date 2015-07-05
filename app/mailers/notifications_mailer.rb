class NotificationsMailer < ActionMailer::Base
  default from: "notifications@example.com"

  def pending_cards(user)
    @review_url = new_review_url
    mail(to: user.email, subject: "Повтори карточки!")
  end
end
