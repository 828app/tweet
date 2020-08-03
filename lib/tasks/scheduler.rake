desc "This task is called by the Heroku scheduler add-on"

task :tweet => :environment do
  $client = Twitter::REST::Client.new do |t|
      t.consumer_key        = ENV["CONSUMER_KEY"]
      t.consumer_secret     = ENV["CONSUMER_SECRET"]
      t.access_token        = ENV["ACCESS_TOKEN"]
      t.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  time = Time.now.to_s.split(' ')
  time = time[1].split(':')
  time = time[0].to_i

  topics = Tweet.where(onoff: 1).where(tweet_time: time)
  topics.each do |tp|

    tweets = $client.search(tp.keyword, count:15, exclude: "retweets", result_type:"recent",min_retweets:tp.retweet,min_faves:tp.favorite)
    i = 0
    tweets.each do |tw|
      break if i >= tp.tweet_num
      break if i > 20 #どんなに多くても上限20回
      if tw.favorite_count >= tp.favorite && tw.retweet_count >= tp.retweet && Date.today - (tw.created_at.to_date) < 1 && !(tw.user.name.include?(tp.keyword)) && !tw.in_reply_to_status_id.is_a?(Integer)
        # puts tw.to_json
        # puts tw.text
        # puts ""
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
      client.destroy_status(tw.id)
    end
  end
end

task :daytweet => :environment do
  client = Twitter::REST::Client.new do |t|
      t.consumer_key        = ENV["CONSUMER_KEY"]
      t.consumer_secret     = ENV["CONSUMER_SECRET"]
      t.access_token        = ENV["ACCESS_TOKEN"]
      t.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end

  random = Random.new
  rnd = random.rand(10)
  agent = Mechanize.new
  page = agent.get("http://yoronjp.org/topics/new")

  elements = page.search('h3 a')
  ele = elements[rnd]
  title = ele.inner_text
  topicid = ele.get_attribute(:href)

  client.update("皆様の意見をお聞かせください。\n【#{title}】\n\nhttp://yoronjp.org#{topicid}")
end

task :test1 => :environment do
  time = Time.now
  puts time
  time= time.since(8.hours)
  puts time
  time= time.to_s.split(' ')
  time = time[1].split(':')
  time = time[0].to_i
  puts time == 2

end


# puts my_user.friends_count #=> フォロー数
# puts my_user.followers_count #=> フォロワー数
# puts my_user.tweets_count #=> ツイート数
