module ApplicationHelper
  def flash_messages
    flashes = flash.map do |type, message|
      content_tag :li, message, class: type
    end
    content_tag(:ul, flashes.join.html_safe, id: :flash)
  end
end
