module UsersHelper
  def user_image(user)
    user.image&.url || 'avatar.png'
  end
end
