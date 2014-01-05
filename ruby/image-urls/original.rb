class Post

  attr_reader :attachment_url

  def initialize(attributes={})
    @attachment_url = attributes[:attachment_url]
  end

  INSTAGRAM_ID  = %r{instagram.com/p/([\w-]+)}

  def image_url
    @image_url ||= get_image_url_from_services || nil
  end

  def image_thumb_url
    @image_thumb_url ||= get_image_thumb_url_from_services
  end

  def get_image_url_from_services
    instagram_url ||
    twitpic_url ||
    twitter_pic_url ||
    yfrog_url
  end

  def get_image_thumb_url_from_services
    instagram_thumb_url ||
    twitpic_thumb_url ||
    twitter_pic_thumb_url ||
    yfrog_thumb_url
  end

  def has_yfrog?
    yfrog_url
  end

  def has_twitter_pic?
    twitter_pic_url
  end

  def has_twitpic?
    twitpic_url
  end

  def has_instagram?
    instagram_url
  end

  def twitter_pic_url
    "#{attachment_url}:medium" if !attachment_url.to_s.scan(TWITTER_PIC).empty?
  end

  def twitter_pic_thumb_url
    "#{attachment_url}:thumb" if twitter_pic_url
  end

  def instagram_url
    attachment_url.to_s.scan(INSTAGRAM_ID).flatten.map do |id|
      "http://instagr.am/p/#{id}/media/?size=m"
    end.first
  end

  def instagram_thumb_url
    attachment_url.to_s.scan(INSTAGRAM_ID).flatten.map do |id|
      "http://instagr.am/p/#{id}/media/?size=t"
    end.first
  end

  def twitpic_url
    attachment_url.to_s.scan(TWITPIC_ID).flatten.map do |id|
      "http://twitpic.com/show/full/#{id}"
    end.first
  end

  def twitpic_thumb_url
    attachment_url.to_s.scan(TWITPIC_ID).flatten.map do |id|
      "http://twitpic.com/show/mini/#{id}"
    end.first
  end

  def yfrog_url
    attachment_url.to_s.scan(YFROG_ID).flatten.map do |id|
      "http://yfrog.com/#{id}:iphone"
    end.first
  end

  def yfrog_thumb_url
    attachment_url.to_s.scan(YFROG_ID).flatten.map do |id|
      "http://yfrog.com/#{id}:small"
    end.first
  end

end
