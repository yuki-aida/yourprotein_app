module UsersHelper
  
  def avatar_for(user, options = { size: "50x50" })
    size = options[:size]
    if user.picture.present?
      image_tag(user.picture.url, alt: user.name, :size => size, class: "user-image")
    else
      image_tag("default.jpg", alt: user.name, :size => size, class: "user-image")
    end
  end
  
end
