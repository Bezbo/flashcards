class NotificationsMailer < ActionMailer::Base
  def pending_cards(user)
    @review_url = new_review_url
    mail(to: user.email, subject: t("review_your_cards")
  end
end
