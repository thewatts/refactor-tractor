class Post

  attr_reader :attachment_url

  def initialize(attributes={})
    @attachment_url = attributes[:attachment_url]
  end
end
