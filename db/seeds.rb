# frozen_string_literal: true

Question.create!(title: 't1', body: 'b1')
Question.create!(title: 't2', body: 'b2')
Question.create!(title: 't3', body: 'b3')
Question.first.answers.push(Answer.new(body: 'a1'))
Question.first.answers.push(Answer.new(body: 'a2'))
Question.first.answers.push(Answer.new(body: 'a3'))
