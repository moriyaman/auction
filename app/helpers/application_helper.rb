module ApplicationHelper
  
  def hbr(str)
str = html_escape(str)
str.gsub(/\r\n|\r|\n/, "<br />")
end

end
