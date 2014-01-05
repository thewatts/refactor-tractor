require 'rspec/autorun'
require_relative 'original'

describe Post do

  it "should have an attachment_url" do
    instagram_url = "http://instagram.com/p/iuuZxfOjEj/"
    p = Post.new(:attachment_url => instagram_url)
    expect(p.attachment_url).to eq instagram_url
  end

  context "posts with pictures" do
    instagram_url       = "http://instagram.com/p/iuuZxfOjEj/"
    twitpic_url         = "http://twitpic.com/1e10q"
    pic_twitter_url     = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.jpg"
    pic_twitter_png_url = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.png"
    yfrog_url           = "http://yfrog.com/oefi8whj"

    let!(:nil_pic)     { Post.new(:attachment_url => nil) }
    let!(:invalid_pic) { Post.new(:attachment_url => "google.com") }
    let!(:insta)       { Post.new(:attachment_url => instagram_url) }
    let!(:twitpic)     { Post.new(:attachment_url => twitpic_url) }
    let!(:t_pic)       { Post.new(:attachment_url => pic_twitter_url) }
    let!(:t_pic_png)   { Post.new(:attachment_url => pic_twitter_png_url) }
    let!(:yfrog)       { Post.new(:attachment_url => yfrog_url) }
    let!(:services)    { [
      insta, twitpic, nil_pic, invalid_pic, t_pic, t_pic_png, yfrog
    ] }

    describe "with an Instagram photo" do
      medium_size_url = "http://instagr.am/p/iuuZxfOjEj/media/?size=m"
      thumb_url       = "http://instagr.am/p/iuuZxfOjEj/media/?size=t"

      it "should have an instagram photo" do
        expect(insta.has_instagram?).to be_true
      end

      it "should return the instagram full url" do
        expect(insta.instagram_url).to eq medium_size_url
      end

      it "should return the instagram thumb url" do
        expect(insta.instagram_thumb_url).to eq thumb_url
      end

      it "should have an instagram url for image_url" do
        expect(insta.image_url).to eq insta.instagram_url
      end

      it "should have an instagram thumb url for thumb_url" do
        expect(insta.image_thumb_url).to eq insta.instagram_thumb_url
      end
    end

    describe "without an instagram photo" do
      it "shouldn't have any instagram jazz" do
        services.each do |tweet|
          next if tweet == insta
          expect(tweet.has_instagram?).to be_false
          expect(tweet.instagram_url).to be_nil
          expect(tweet.instagram_thumb_url).to be_nil
        end
      end
    end
  end
end
