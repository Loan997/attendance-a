# ユーザー
User.create(name:  "Example User",
             email: "example@railstutorial.org",
             affiliation: "system",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             )
             
User.create(name:  "Superior1",
             email: "superior1@railstutorial.org",
             affiliation: "sales",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             designated_working_start_time: "9:00",
             designated_working_end_time: "18:00",
             employee_number: 1111,
             basic_time: "9:00",
             superior: 1
             )
             
User.create(name:  "Superior2",
             email: "superior2@railstutorial.org",
             affiliation: "sales",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             designated_working_start_time: "9:30",
             designated_working_end_time: "18:30",
             employee_number: 2222,
             basic_time: "9:00",
             superior: 1
             )
             
User.create(name:  "User1",
             email: "user1@railstutorial.org",
             affiliation: "sales",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             designated_working_start_time: "10:00",
             designated_working_end_time: "19:00",
             employee_number: 3333,
             basic_time: "8:00",
             superior: 0
             )
             
User.create(name:  "User2",
             email: "user2@railstutorial.org",
             affiliation: "sales",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             designated_working_start_time: "10:30",
             designated_working_end_time: "19:30",
             employee_number: 4444,
             basic_time: "8:00",
             superior: 0
             )
             
ApplyingState.create(
  status: "なし"
  )
  
ApplyingState.create(
  status: "申請中"
  )
  
ApplyingState.create(
  status: "承認"
  )
  
ApplyingState.create(
  status: "否認"
  )
             
# TimeBasicInformation.create!(
#     designated_working_times: "8:00",
#     basic_time: "7:50"
#     )
