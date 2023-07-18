# frozen_string_literal: true

if Rails.env == 'production'
  admin = User.create!(email: 'uhf_job@mail.ru',
                       password: Rails.application.credentials[:production][:admin][:password],
                       admin: true)
  user = User.create!(email: 'proekt-1987@yandex.ru',
                       password: Rails.application.credentials[:production][:user][:password])
  q1 = admin.questions.create(title: Faker::Markdown.emphasis, body: Faker::Quote.famous_last_words)
  q2 = admin.questions.create(title: Faker::Markdown.emphasis, body: Faker::Quote.famous_last_words)
  q1.votes.create(user: user, liked: true)
  q3 = admin.questions.create(title: Faker::Markdown.emphasis, body: Faker::Quote.famous_last_words)
  Subscription.destroy_all
  q1.answers.create(user: user, body: Faker::Markdown.emphasis)
  q1.answers.last.votes.create(user: admin, liked: true)
  q1.answers.create(user: admin, body: Faker::Quote.famous_last_words)
  q1.answers.last.votes.create(user: user, liked: false)
  q1.answers.create(user: user, body: Faker::Markdown.emphasis)
  q1.answers.last.votes.create(user: admin, liked: false)
  q2.answers.create(user: admin, body: Faker::Quote.famous_last_words)
  q2.answers.last.votes.create(user: user, liked: true)
  q2.answers.create(user: user, body: Faker::Markdown.emphasis, best: true)
  q2.answers.last.votes.create(user: admin, liked: true)
  q2.answers.create(user: user, body: Faker::Markdown.emphasis)
  q3.answers.create(user: user, body: Faker::Markdown.emphasis, best: true)
else
  user1 = User.create!(email: 'some0@mail.nett', password: '123456')
  user2 = User.create!(email: 'some1@mail.nett', password: '123456')
  user1.questions.create!(title: 't1', body: 'b1')
  user1.questions.create!(title: 't2', body: 'b2')
  user1.questions.create!(title: 't3', body: 'b3')
  Question.first.answers.create!(user: user1, body: 'a1', best: true)
  Question.first.answers.create!(user: user2, body: 'a2')
  Question.find(2).answers.create!(user: user1, body: 'a1')
  Question.find(2).answers.create!(user: user1, body: 'a2')
  Question.last.answers.create!(user: user1, body: 'a1')
  Question.last.answers.create!(user: user1, body: 'a2', best: true)
  Question.last.answers.create!(user: user1, body: 'a3')
end
