class Post < ApplicationRecord
    belongs_to :user
    has_many :comments
    
    words = ["fuck", "shit", "bitch"]
    
    before_save{
        words.each do |word|
            len = word.length
            self.title.gsub!(/#{word}/, '*'*len) if(self.title.include?(word))
            self.content.gsub!(/#{word}/, '*'*len) if(self.content.include?(word))
        end
    }
end
