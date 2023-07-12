# frozen_string_literal: true

class SearchesController < ApplicationController
  skip_authorization_check
  CHARACTERS_MINIMUM_COUNT = 3

  def index; end

  def search
    @keyword = params[:query]
    @author = params[:author]
    search_for_restricted_chars
    perform_search if queries_minimum_size && @restricted_chars.empty?
  end

  private

  def search_for_restricted_chars
    @restricted_chars = ""
    "#{@keyword}#{@author}".each_char do |char|
      @restricted_chars += char if char !~ /\w/
    end
  end

  def queries_minimum_size
    keyword_check = true if @keyword.size >= CHARACTERS_MINIMUM_COUNT
    author_check = true if (@author.present? && @author.size >= CHARACTERS_MINIMUM_COUNT) || @author.empty?
    @queries_minimum_size = keyword_check && author_check ? true : false
  end

  def perform_search
    @result = []
    query(Question, %i[title body], @author) if params[:questions] == '1'
    query(Answer, [:body], @author) if params[:answers] == '1'
    query(Comment, [:body], @author) if params[:comments] == '1'
    query(User, [:email], nil) if params[:users] == '1'
  end

  def query(model, fields, author)
    if author
      model.search(conditions: { fields => @keyword, author: @author }, star: true).each { |q| @result.push(q) }
    else
      model.search(conditions: { fields => @keyword }, star: true).each { |q| @result.push(q) }
    end
  end
end
