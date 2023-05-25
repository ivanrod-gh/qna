# frozen_string_literal: true

user1 = User.create!(email: 'some0@mail.net', password: '123456')
user2 = User.create!(email: 'some1@mail.net', password: '123456')
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
