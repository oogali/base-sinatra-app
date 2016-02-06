FactoryGirl.define do
  factory :user, class: AppName::Db::User do
    sequence(:username) { |n| "user#{n}@appname.com" }
    sequence(:name) { |n| "user#{n}" }
    initialize_with { AppName::Db::User.find_or_create_by(username: username, name: name) }

    factory :johnny_appleseed do
      username 'johnny@iloveapples.com'
      name 'Johnny Appleseed'
    end
  end
end
