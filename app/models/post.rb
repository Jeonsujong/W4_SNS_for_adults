class Post < ApplicationRecord
    belongs_to :user
    has_many :comments
    
    words = ["fuck", "shit", "bitch"]
    
    before_save{
        words.each do |word|
            len = word.length
            if(self.title.include?(word))
                self.title.gsub!(/#{word}/, '*'*len)
            elsif(self.content.include?(word))
                   self.content.gsub!(/#{word}/, '*'*len)
            end
        end
    }
end
