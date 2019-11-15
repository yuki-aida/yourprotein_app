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
