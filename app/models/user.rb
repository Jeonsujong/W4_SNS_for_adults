class User < ApplicationRecord
    has_many :posts
    has_many :comments
    
    RegExp = /01[167890]-\d{3,4}-\d{4}/
    
    validates :name, length: {maximum: 10}, presence: true
    validates :age, numericality: {only_integer: true,
                    greather_than: 19, presence: true}
    validates :phone, format: {with: RegExp},
                      uniqueness: {case_sensitive: false},
                      presence: true
end
