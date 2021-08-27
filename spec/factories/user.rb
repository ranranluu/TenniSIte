FactoryBot.define do
  factory :user do
    nickname {Faker::Name.name}
    email {Faker::Internet.free_email}
    password = Faker::Internet.password(min_length: 6)
    password {password}
    password_confirmation {password}
    introduction {"テニス大好き"}
    playstyle {"オールラウンダー"}
    like_player {"錦織圭"}
    like_brand {"ダンロップ"}
  end
end