require 'rspec/autorun'
require_relative 'original'

describe Post do

  it "should have an attachment_url" do
    instagram_url = "http://instagram.com/p/iuuZxfOjEj/"
    p = Post.new(:attachment_url => instagram_url)
    expect(p.attachment_url).to eq instagram_url
  end
end
