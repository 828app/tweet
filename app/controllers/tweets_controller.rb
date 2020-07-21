class TweetsController < ApplicationController
  before_action :require_login,except: [:index, :login]

  def tweet
      @tweets = Tweet.order("updated_at DESC")
  end

  def create
    posting = Tweet.new(create_params)
    if posting.save
      redirect_to action: 'tweet'
    end
  end

  def edit
    tweet = Tweet.find(params[:id])
    tweet.topicid = params[:topicid]
    tweet.title = params[:title]
    tweet.keyword = params[:keyword]
    tweet.favorite =  params[:favorite]
    tweet.retweet = params[:retweet]
    tweet.tweet_num = params[:tweet_num]
    tweet.tweet_time = params[:tweet_time]
    tweet.save
    redirect_to action: 'tweet'
  end

  def delete
    Tweet.find(params[:id]).destroy
    redirect_to action: 'tweet'
  end

  def onoff
    tweet = Tweet.find(params[:id])
    if tweet.onoff == 1
      tweet.onoff = 0
    else
      tweet.onoff = 1
    end
    tweet.save
    redirect_to action: 'tweet'
  end

  def login
    if params[:password]== ENV["LOGIN_KEY"]
       session[:loginsession] = "loginsessi"
       # logger.debug("セッション作成")
       redirect_to action: 'tweet'
    else
       redirect_to action: 'index'
    end

  end

  private
  def create_params
    params[:onoff]=1
      params.permit(:topicid, :title, :keyword,:favorite,:retweet,:tweet_num,:tweet_time,:onoff)
  end

  def require_login
    if session[:loginsession].nil?
     redirect_to action: 'index'
    end
  end
end
