# データベース上にサンプルユーザーを生成するRailsタスク
# まだ詳細が完全に理解できなくても良い

# create!は基本的にはcreateと同じだが、ユーザーが無効の場合falseではなく例外を発生
# させる
User.create!(name:  "Yuki Aida",
             email: "yukiaida21@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             profile: "I like bench press.")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  profile = "I like aquat"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               profile: profile)
end

# 作成されたユーザーの最初の6人を明示的に呼び出す
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(5)
  title = "My Protein"
  category = "others"
  users.each { |user| user.microposts.create!(content: content, title: title, category: category) }
end
10.times do
  content = Faker::Lorem.sentence(5)
  title = "My Protein"
  category = "protein"
  users.each { |user| user.microposts.create!(content: content, title: title, category: category) }
end
10.times do
  content = Faker::Lorem.sentence(5)
  title = "My Protein"
  category = "training_items"
  users.each { |user| user.microposts.create!(content: content, title: title, category: category) }
end
10.times do
  content = Faker::Lorem.sentence(5)
  title = "My Protein"
  category = "wear"
  users.each { |user| user.microposts.create!(content: content, title: title, category: category) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
# 最初のユーザーが2..50番目までのユーザーをフォローする
following.each { |followed| user.follow(followed) }
# 3..40番目までのユーザーが最初のユーザーをフォローする
followers.each { |follower| follower.follow(user) }
