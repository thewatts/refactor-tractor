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

    describe "with a TwitPic photo" do
      medium_size_url = "http://twitpic.com/show/full/1e10q"
      thumb_url       = "http://twitpic.com/show/mini/1e10q"

      it "should have a twitpic photo" do
        expect(twitpic.has_twitpic?).to be_true
      end

      it "should return the twitpic full url" do
        expect(twitpic.twitpic_url).to eq medium_size_url
      end

      it "should return the twitpic thumb url" do
        expect(twitpic.twitpic_thumb_url).to eq thumb_url
      end

      it "should have a twitpic url for image_url" do
        expect(twitpic.image_url).to eq twitpic.twitpic_url
      end
    end

    describe "without a twitpic photo" do
      it "shouldn't have any twitpic jazz" do
        services.each do |tweet|
          next if tweet == twitpic
          expect(tweet.has_twitpic?).to be_false
          expect(tweet.twitpic_url).to be_nil
          expect(tweet.twitpic_thumb_url).to be_nil
        end
      end
    end

    describe "with an pic.twitter.com photo" do
      medium_size_jpg = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.jpg:medium"
      thumb_jpg       = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.jpg:thumb"
      medium_size_png = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.png:medium"
      thumb_png       = "https://pbs.twimg.com/media/BdLBbkpCcAAspZn.png:thumb"

      it "should have an instagram photo" do
        expect(t_pic.has_twitter_pic?).to be_true
        expect(t_pic_png.has_twitter_pic?).to be_true
      end

      it "should return the twitter_pic full url" do
        expect(t_pic.twitter_pic_url).to eq medium_size_jpg
        expect(t_pic_png.twitter_pic_url).to eq medium_size_png
      end

      it "should return the twitter_pic thumb url" do
        expect(t_pic.twitter_pic_thumb_url).to eq thumb_jpg
        expect(t_pic_png.twitter_pic_thumb_url).to eq thumb_png
      end

      it "should have an twitter_pic url for image_url" do
        expect(t_pic.image_url).to eq t_pic.twitter_pic_url
        expect(t_pic_png.image_url).to eq t_pic_png.twitter_pic_url
      end

      it "should have an twitter_pic thumb url for thumb_url" do
        expect(t_pic.image_thumb_url).to eq t_pic.twitter_pic_thumb_url
        expect(t_pic_png.image_thumb_url).to eq t_pic_png.twitter_pic_thumb_url
      end
    end

    describe "without an pic.twitter.com photo" do
      it "shouldn't have any pic.twitter.com jazz" do
        services.each do |tweet|
          next if ( tweet == t_pic || tweet == t_pic_png )
          expect(tweet.has_twitter_pic?).to be_false
          expect(tweet.twitter_pic_url).to be_nil
          expect(tweet.twitter_pic_thumb_url).to be_nil
        end
      end
    end

    describe "with a yfrog photo" do
      medium_size_url = "http://yfrog.com/oefi8whj:iphone"
      thumb_url       = "http://yfrog.com/oefi8whj:small"

      it "should have an yfrog  photo" do
        expect(yfrog.has_yfrog?).to be_true
      end

      it "should return the yfrog full url" do
        expect(yfrog.yfrog_url).to eq medium_size_url
      end

      it "should return the twitter_pic thumb url" do
        expect(yfrog.yfrog_thumb_url).to eq thumb_url
      end

      it "should have an yfrog url for image_url" do
        expect(yfrog.image_url).to eq yfrog.yfrog_url
      end

      it "should have an yfrog thumb url for thumb_url" do
        expect(yfrog.image_thumb_url).to eq yfrog.yfrog_thumb_url
      end
    end

    describe "without an yfrog photo" do
      it "shouldn't have any instagram jazz not instagram" do
        services.each do |tweet|
          next if tweet == yfrog
          expect(tweet.has_yfrog?).to be_false
          expect(tweet.yfrog_url).to be_nil
          expect(tweet.yfrog_thumb_url).to be_nil
        end
      end
    end
  end
end
