FactoryBot.define do
  factory :user do
    username { "Aku Ankka" }
    password { "3Veljenpoikaa" }
    password_confirmation { "3Veljenpoikaa" }
  end
  
  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :beer do
    name { "anonymous" }
    style { "lager" }
    brewery
  end
  
  factory :rating do
    score { 10 }
    beer
    user    
  end
end 