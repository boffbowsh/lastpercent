# hack for passenger so it resizes images properly
# change path to where you installed imagemagick
if Rails.env.development?
  Paperclip.options[:image_magick_path] = '/opt/local/bin/'
end
 
class Paperclip::Attachment
  def self.default_options
    @default_options ||= {
      :url           => "/system/:attachment/:id/:style/:filename",
      :path          => ":rails_root/public:url",
      :styles        => {},
      :default_url   => "/images/default_:attachment_:style.png",
      :default_style => :original,
      :validations   => [],
      :storage       => :filesystem,
      :whiny         => Paperclip.options[:whiny] || Paperclip.options[:whiny_thumbnails]
    }
  end
end
