class Post

  attr_reader :attachment_url

  def initialize(attributes={})
    @attachment_url = attributes[:attachment_url]
  end

  TWITPIC_ID    = %r{twitpic.com/([a-zA-Z0-9]+)}
  POSTEROUS_ID  = %r{post.ly/([a-zA-Z0-9]+)}
  TWEETPHOTO_ID = %r{(pic.gd|tweetphoto.com)/([a-zA-Z0-9]+)}
  YFROG_ID      = %r{yfrog.[^/]+/([a-zA-Z0-9]+[jptg])}
  TWITTER_PIC   = %r{pbs.twimg.com/media/([\w]+)}
  INSTAGRAM_ID  = %r{instagram.com/p/([\w-]+)}

  def image_url
    @image_url ||= full_url_from_present_image_service || nil
  end

  def image_thumb_url
    @image_thumb_url ||= thumb_url_from_present_image_service
  end

  def image_services
    [
      :instagram,
      :twitpic,
      :yfrog,
      :twitter_pic
    ]
  end

  def full_url_from_present_image_service
    service, url = present_image_service_data
    send(service)[:full_url].call url
  end

  def thumb_url_from_present_image_service
    service, url = present_image_service_data
    send(service)[:thumb_url].call url
  end

  def present_image_service_data
    @present_image_service_data ||= image_services.map do |service|
      url = attachment_url.to_s.scan(send(service)[:regex]).flatten.first
      [service, url] if url
    end.compact.flatten
  end

  def instagram
    {
      :regex     => INSTAGRAM_ID,
      :full_url  => ->(id) { "http://instagr.am/p/#{id}/media/?size=m" },
      :thumb_url => ->(id) { "http://instagr.am/p/#{id}/media/?size=t" }
    }
  end

  def yfrog
    {
      :regex     => YFROG_ID,
      :full_url  => ->(id) { "http://yfrog.com/#{id}:iphone" },
      :thumb_url => ->(id) { "http://yfrog.com/#{id}:small" }
    }
  end

  def twitpic
    {
      :regex     => TWITPIC_ID,
      :full_url  => ->(id) { "http://twitpic.com/show/full/#{id}" },
      :thumb_url => ->(id) { "http://twitpic.com/show/mini/#{id}" }
    }
  end

  def twitter_pic
    {
      :regex     => TWITTER_PIC,
      :full_url  => ->(id) { "#{attachment_url}:medium" if id },
      :thumb_url => ->(id) { "#{attachment_url}:thumb" if id}
    }
  end

  def has_yfrog?
    present_image_service_data.include?(:yfrog)
  end

  def has_twitter_pic?
    present_image_service_data.include?(:twitter_pic)
  end

  def has_twitpic?
    present_image_service_data.include?(:twitpic)
  end

  def has_instagram?
    present_image_service_data.include?(:instagram)
  end

end
