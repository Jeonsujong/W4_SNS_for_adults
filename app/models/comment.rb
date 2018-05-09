class Comment < ApplicationRecord
    belongs_to :post
    
    words = ["fuck", "shit", "bitch"]
    
    before_save{
        words.each do |word|
            len = word.length
            if(self.content.include?(word))
                self.content.gsub!(/#{word}/, '*'*len)
            end
        end
    }
    
    validates :content, length: {maximum: 100}
end
