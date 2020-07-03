desc "This task is called by the Heroku scheduler add-on"


task :tweet => :environment do
  $client = Twitter::REST::Client.new do |t|
      t.consumer_key        = ENV["CONSUMER_KEY"]
      t.consumer_secret     = ENV["CONSUMER_SECRET"]
      t.access_token        = ENV["ACCESS_TOKEN"]
      t.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end

  topics = Tweet.where("onoff = 1")
  topics.each do |tp|

    tweets = $client.search(tp.keyword, count: 10, result_type: "recent", exclude: "retweets")
    i = 0
    tweets.each do |tw|
      break if i > tp.tweet_num
      break if i > 3 #どんなに多くても上限５０回
      if tw.favorite_count >= tp.favorite && tw.retweet_count >= tp.retweet
        puts tw.to_json
        puts tw.text
        puts ""
         $client.update("@#{tw.user.screen_name}\n皆様の意見をお聞かせください。\n【#{tp.title}】\n\nhttp://yoronjp.org/topics/#{tp.topicid}", options = {:in_reply_to_status_id => tw.id})
        i += 1
      end
    end
  end
end

task :delete => :environment do
  client = Twitter::REST::Client.new do |t|
    t.consumer_key        = ENV["CONSUMER_KEY"]
    t.consumer_secret     = ENV["CONSUMER_SECRET"]
    t.access_token        = ENV["ACCESS_TOKEN"]
    t.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end

  client.user_timeline(:count => 800).each do |tw|
    time = tw.created_at
    if Date.today - (time.to_date) > 7 then
      puts tw.id
      puts tw.favorite_count
      # client.destroy_status(tw.id)
    end
  end
end


# puts my_user.friends_count #=> フォロー数
# puts my_user.followers_count #=> フォロワー数
# puts my_user.tweets_count #=> ツイート数
