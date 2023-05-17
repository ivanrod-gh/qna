# frozen_string_literal: true

user = User.create(email: 'some0@mail.net', password: '123456')
user.questions.create!(title: 't1', body: 'b1')
user.questions.create!(title: 't2', body: 'b2')
user.questions.create!(title: 't3', body: 'b3')
Question.first.answers.create!(user: user, body: 'a1')
Question.first.answers.create!(user: user, body: 'a2')
Question.first.answers.create!(user: user, body: 'a3')
