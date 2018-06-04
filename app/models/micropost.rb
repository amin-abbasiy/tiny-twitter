class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  mount_uploader(:picture, PictureUploader) 
  validates(:user_id, presence: true)
  validates(:content, presence: true, length: {maximum: 140})
  validate(:picture_size)


  def picture_size
      if picture.size > 5.megabytes then
         errors.add(:picture, "Image Size Cant Be More Than 5MB")
      end
  end

end
