module ApplicationHelper
  def get_image(image, width, height)
    image.variant(resize_to_limit: [width, height])
  end

  def current_user?(user)
    user == current_user
  end
end
