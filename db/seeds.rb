# データベース上にサンプルユーザーを生成するRailsタスク
# まだ詳細が完全に理解できなくても良い

# create!は基本的にはcreateと同じだが、ユーザーが無効の場合falseではなく例外を発生
# させる
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# 作成されたユーザーの最初の6人を明示的に呼び出す
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
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
