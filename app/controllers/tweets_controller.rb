class TweetsController < ApplicationController
  def tweet
      @tweets = Tweet.order("updated_at DESC")
  end

  def create
    posting = Tweet.new(create_params)
          if posting.save
            redirect_to action: 'tweet'

          end


  end


  private
  def create_params
      params.permit(:topicid, :title, :keyword,:favorite,:retweet)
        # params.require(:posting).permit(:topicid, :title, :keyword,:favorite,:retweet)
      #「params が :posting というキーを持ち、params[:posting] は :name、:age、:sex....というキーを持つハッシュであること」を検証しているそうです。
  end
end
