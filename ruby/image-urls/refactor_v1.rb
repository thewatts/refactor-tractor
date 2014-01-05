class Post

  attr_reader :attachment_url

  def initialize(attributes={})
    @attachment_url = attributes[:attachment_url]
  end

  def image_url
    @image_url ||= image_url_of_size(:full)
  end

  def image_thumb_url
    @image_thumb_url ||= image_url_of_size(:thumb)
  end

  def image_type
    present_image_service_data.first
  end

  def image_services
    [
      :instagram,
      :twitpic,
      :yfrog,
      :twitter_pic
    ]
  end

  private

  def image_url_of_size(size)
    service, url = present_image_service_data
    send(service)[size].call url if service
  end

  def present_image_service_data
    @present_image_service_data ||= image_services.map do |service|
      url = attachment_url.to_s.scan(send(service)[:regex]).flatten.first
      [service, url] if url
    end.compact.flatten
  end

  def instagram
    {
      :regex     => %r{instagram.com/p/([\w-]+)},
      :full  => ->(id) { "http://instagr.am/p/#{id}/media/?size=m" },
      :thumb => ->(id) { "http://instagr.am/p/#{id}/media/?size=t" }
    }
  end

  def yfrog
    {
      :regex     => %r{yfrog.[^/]+/([a-zA-Z0-9]+[jptg])},
      :full  => ->(id) { "http://yfrog.com/#{id}:iphone" },
      :thumb => ->(id) { "http://yfrog.com/#{id}:small" }
    }
  end

  def twitpic
    {
      :regex     => %r{twitpic.com/([a-zA-Z0-9]+)},
      :full  => ->(id) { "http://twitpic.com/show/full/#{id}" },
      :thumb => ->(id) { "http://twitpic.com/show/mini/#{id}" }
    }
  end

  def twitter_pic
    {
      :regex     => %r{pbs.twimg.com/media/([\w]+)},
      :full  => ->(id) { "#{attachment_url}:medium" if id },
      :thumb => ->(id) { "#{attachment_url}:thumb" if id}
    }
  end

end
