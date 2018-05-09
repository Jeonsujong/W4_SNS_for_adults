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