class SearchesController < ApplicationController
  skip_authorization_check
  CHARACTERS_MINIMUM_COUNT = 3

  def index; end

  def search
    @keyword = params[:query]
    @author = params[:author]
    search_for_restricted_chars(@keyword, @author)

    if @keyword.size >= CHARACTERS_MINIMUM_COUNT && ((@author.present? && @author.size >= CHARACTERS_MINIMUM_COUNT) || @author.empty?) && @restricted_chars.empty?
      perform_search
    end
  end

  private

  def search_for_restricted_chars(keyword, author)
    @restricted_chars = ""
    "#{keyword}#{author}".each_char do |symbol|
      @restricted_chars += symbol if symbol  !~ /\w/
    end
  end

  def perform_search
    author_string = params[:author].present? ? ", author: '#{params[:author]}'" : nil
    @result = []
    query('Question', ':title, :body', author_string) if params[:questions] == '1'
    query('Answer', ':body', author_string) if params[:answers] == '1'
    query('Comment', ':body', author_string) if params[:comments] == '1'
    query('User', ':email', nil) if params[:users] == '1'
  end

  def query(model, fields, author_string)
    each = "each { |q| @result.push(q)"
    eval "#{model}.search(conditions: { [#{fields}] => @keyword #{author_string} }, star: true).#{each} }"
  end
end
