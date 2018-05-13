### 1. 목표
 4주차 강의에서 배웠던 내용을 바탕으로, 성인용 SNS의 데이터베이스를 설계한다. 모든 내용은 task파일을 사용하여 입력하며, faker gem을 통해 모델에 더미 데이터를 활용한다.

### 2. 모델 속성 표
Table: users

|   id   | Name     | Phone       | Age |
|--------|----------|-------------|-----|
|integer |  string  |string|  integer |

Table: posts

| id      | Title    | Content          | User   |
|---------|----------|------------------|------  |
| integer |string    | text             | string |

Table: comments

| id      | Content           | Post   |
|---------|-------------------|--------|
| integer |       text        | string |



### 3. 각각 모델 코드
User.rb
```
class User < ApplicationRecord
    has_many :posts
    
    RegExp = /01[167890]-\d{3,4}-\d{4}/
    
    validates :name, length: {maximum: 10}, presence: true
    validates :age, numericality: {only_integer: true,
                    greather_than: 19, presence: true}
    validates :phone, format: {with: RegExp},
                      uniqueness: {case_sensitive: false},
                      presence: true
end
```

post.rb
```
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
```

comment.rb
```
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
```

### 4. Schema.rb
```
ActiveRecord::Schema.define(version: 20180508060133) do

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
```

### 5. .task파일
```
namespace :table_task do
    desc "All"
    task all: [:random_user, :post_data, :comment_data]
    
    desc "Insert_User_Information"
    task random_user: :environment do
            20.times do
            User.create(name: Faker::Name.unique.name[1..10], age: Faker::Number.between(20, 29),
						phone: Faker::Base.numerify('010-####-####'))
    		end
    		
    		10.times do
            User.create(name: Faker::Name.unique.name[1..10], age: Faker::Number.between(30, 39),
						phone: Faker::Base.numerify('010-####-####'))
    		end
    		
    		5.times do
            User.create(name: Faker::Name.unique.name[1..10], age: Faker::Number.between(40, 49),
						phone: Faker::Base.numerify('010-####-####'))
    		end
    		
        	5.times do
            User.create(name: Faker::Name.unique.name[1..10], age: Faker::Number.between(50, 59),
						phone: Faker::Base.numerify('010-####-####'))
    		end
    end
    
    desc "Insert_Post_Information"
    task post_data: :environment do
        t_ment = ["만나서 반갑습니다.", "지나가다 들렸습니다.", "바람이 불어오는 계절",
                  "Fuck that shit", "Come on bitches", "I don't think so bro",
                  "We Make A Difference", "I'll hum it for you", "Good night"]
                
        c_ment = ["저랑 괌 가실 분 괌", "인정? 어 인정", "내용 없음",
                  "We go to the party", "Oh, A little rusty", "fuckin biaaatch",
                  "와타시와 칸코쿠진 데스", "I don't know what to do", "Come on"]
                
        for i in 1..40
            if User.find(i).age > 49
                Post.create title: t_ment.sample, 
                            content: c_ment.sample,
                            user_id: User.find(i).id
            end                    
        end
    end
    
    desc "Insert_Comment_Information"
    task comment_data: :environment do
        c_ment2 = ["노잼이네요.", "안녕하세요", "제 계정에도 놀러오세요",
                   "응 아니야", "What the fuck", "Oh shit",
                   "나루호도", "??", "무슨 말씀이신지,,"]
                
        for i in 1..40
            if User.find(i).age > 39 && User.find(i).age < 50
              j = Random.new.rand(1..2)
              Comment.create content: c_ment2.sample, 
                             post_id: Post.find(j).id
            end                    
        end
    end
end
```

### 6. 오류 내용 + 오류 해결과정
오류보다도 명령어가 기억이 안 난다던지, 어디서부터 접근해야 해결할 수 있는지 고민하는 데에 많은 시간을 보냈다. 오류의 대부분은 내가 잘 알지 못해서, 잘못 접근해서 일어난 것이라 할 수 있다. 하지만 주목할만한 오류가 한 가지 있었다. 그리고 왜 이러한 현상이 일어나는지 아직 해답을 구하지 못했다.

그 오류는 휴대폰 정규표현식을 적용하는 과정에 일어났다. 먼저 구글링을 통해 정규표현식을 찾았다.

`/^01[167890]-\d{3,4}-\d{4}$/`

위와 같은 정규식을 발견했고, 적용했다. 하지만

`ArgumentError: The provided regular expression is using multiline anchors (^ or $), which may present a security risk. Did you mean to use \A and \z, or forgot to add the :multiline => true option?`

오류 메세지와 맞닥뜨렸다. 오류 메세지 내용을 보면 '^'와 '$' 문자를 사용한 것이 잘못인 것 같았다. 그래서 그냥 지워보고 다시 해봤는데 오류없이 잘 실행되었다.

위의 정규식을 참고한 블로그를 보면 
`^는 반드시 문자열의 맨 처음부터 매치되어야 함을 뜻함.
$는 반드시 문자열의 맨 마지막까지 매치되어야 함.`

이라고 되어있다. 때문에 무엇이 잘못되어서 ArgumentError가 발생했는지, 그리고 문제의 '^'와 '$'를 제거하자마자 잘 실행이 되었는지 아직 궁금증으로 남아있다.


### 7. 참고문서 링크

1. 건대 멋사 4주차 수업자료 Model
2. http://gamtoggi.tistory.com/entry/
3. ActiveRecord::FinderMethods
4. https://opentutorials.org/module/517
5. https://bluesh55.github.io/2016/10/23/rake-task/