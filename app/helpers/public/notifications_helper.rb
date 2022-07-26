module Public::NotificationsHelper
  def unchecke_notificatons
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
