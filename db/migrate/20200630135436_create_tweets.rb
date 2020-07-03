class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.integer :topicid
      t.string :title
      t.string :keyword
      t.integer :favorite
      t.integer :retweet
      t.integer :tweet_num
      t.integer :onoff
      t.timestamps
    end
  end
end
