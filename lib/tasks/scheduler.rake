desc "This task is called by the Heroku scheduler add-on"
task :tweet => :environment do
  $client = Twitter::REST::Client.new do |t|
      t.consumer_key        = ENV["CONSUMER_KEY"]
      t.consumer_secret     = ENV["CONSUMER_SECRET"]
      t.access_token        = ENV["ACCESS_TOKEN"]
      t.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end


  tweets = $client.search("寿司　食べたい", count: 10, result_type: "recent", exclude: "retweets")
  i = 0
  tweets.each do |tw|
    break if i > 5
    # puts tw.to_json
    puts tw.text
    puts ""
    # $client.update("@#{tw.user.screen_name}\n５５", options = {:in_reply_to_status_id => tw.id})
    i += 1
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
