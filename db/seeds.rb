# ユーザー
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             affiliation: "system",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             )
             
User.create!(name:  "User",
             email: "user@railstutorial.org",
             affiliation: "sales",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             )
             
TimeBasicInformation.create!(
    designated_working_times: "8:00",
    basic_time: "7:50"
    )
