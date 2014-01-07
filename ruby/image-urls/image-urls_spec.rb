require 'rspec/autorun'
require_relative 'refactor_v1'

describe Post do

  it "should have an attachment_url" do
    instagram_url = "http://instagram.com/p/iuuZxfOjEj/"
    p = Post.new(:attachment_url => instagram_url)
    expect(p.attachment_url).to eq instagram_url
  end

  context "without pictures" do
    let!(:post) { Post.new(:attachment_url => nil) }

    it "shouldn't have an attachment_url if one isn't given" do
      expect(post.attachment_url).to be_nil
    end

    it "should have nil as an image_url, if attachment is nil" do
      expect(post.image_url).to be_nil
    end

    it "shouldn't have an image type" do
      expect(post.image_type).to be_nil
    end
  end

  context "with pictures" do
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

      xit "should have an instagram photo" do
        expect(insta.image_type).to eq :instagram
      end

      it "should have an instagram url for image_url" do
        expect(insta.image_url).to eq medium_size_url
      end

      it "should have an instagram thumb url for thumb_url" do
        expect(insta.image_thumb_url).to eq thumb_url
      end
    end

    describe "without an instagram photo" do
      it "shouldn't have any instagram jazz" do
        services.each do |tweet|
          next if tweet == insta
          expect(tweet.image_type).not_to eq :instagram
        end
      end
    end

    describe "with a TwitPic photo" do
      medium_size_url = "http://twitpic.com/show/full/1e10q"
      thumb_url       = "http://twitpic.com/show/mini/1e10q"

      xit "should have a twitpic photo" do
        expect(twitpic.image_type).to eq :twitpic
      end

      it "should have a twitpic url for image_url" do
        expect(twitpic.image_url).to eq medium_size_url
      end

      it "should have a twitpic thumb url for image_thumb_url" do
        expect(twitpic.image_thumb_url).to eq thumb_url
      end
    end

    describe "without a twitpic photo" do
      it "shouldn't have any twitpic jazz" do
        services.each do |tweet|
          next if tweet == twitpic
          expect(tweet.image_type).not_to eq :twitpic
        end
      end
    end

    describe "with an twitter_pic photo" do
      medium_size_jpg = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.jpg:medium"
      thumb_jpg       = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.jpg:thumb"
      medium_size_png = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.png:medium"
      thumb_png       = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.png:thumb"

      xit "should have a twitter_pic photo" do
        expect(t_pic.image_type).to eq :twitter_pic
      end

      it "should have an twitter_pic url for image_url" do
        expect(t_pic.image_url).to eq medium_size_jpg
        expect(t_pic_png.image_url).to eq medium_size_png
      end

      it "should have an twitter_pic thumb url for thumb_url" do
        expect(t_pic.image_thumb_url).to eq thumb_jpg
        expect(t_pic_png.image_thumb_url).to eq thumb_png
      end
    end

    describe "without an twitter_pic photo" do
      it "shouldn't have any pic.twitter.com jazz" do
        services.each do |tweet|
          next if ( tweet == t_pic || tweet == t_pic_png )
          expect(tweet.image_type).not_to eq :twitter_pic
        end
      end
    end

    describe "with a yfrog photo" do
      medium_size_url = "http://yfrog.com/oefi8whj:iphone"
      thumb_url       = "http://yfrog.com/oefi8whj:small"

      xit "should have an yfrog  photo" do
        expect(yfrog.image_type).to eq :yfrog
      end

      it "should have an yfrog url for image_url" do
        expect(yfrog.image_url).to eq medium_size_url
      end

      it "should have an yfrog thumb url for thumb_url" do
        expect(yfrog.image_thumb_url).to eq thumb_url
      end
    end

    describe "without an yfrog photo" do
      it "shouldn't have any yfrog jazz" do
        services.each do |tweet|
          next if tweet == yfrog
          expect(tweet.image_type).not_to eq :yfrog
        end
      end
    end
  end
end
