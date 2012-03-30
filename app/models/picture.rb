 #coding: utf-8

class Picture < ActiveRecord::Base
  belongs_to :item
  
validate :valid_size?
  
def valid_filename?
   ps = [ 'image/jpeg', 'image/gif', 'image/png' ]
    errors.add('画像ファイルではありません。戻るで前のページへ戻り再度画像を選択して下さい。') if !ps. include?(self.content_type)
end


private
  def valid_size?
    errors.add('画像のサイズが1MBを超えています。戻るで前のページへ戻り再度画像を選択して下さい。') if self.photo.size > 1.megabyte
  end

end
