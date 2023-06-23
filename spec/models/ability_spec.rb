require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  
  describe 'for guest' do
    let(:user) { nil }

    it { should     be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end
  
  describe 'for admin' do
    let(:user) { create :user, admin: true }
    
    it { should     be_able_to :manage, :all }
  end
  
  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, user: user }
    let(:another_user) { create :user }
    let(:another_question) { create :question, user: another_user }
    let(:another_answer) { create :answer, user: another_user }
    
    it { should     be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should     be_able_to :create, Question }
    it { should     be_able_to :create, Answer }
    it { should     be_able_to :create, Comment }
    
    it { should     be_able_to :update, question }
    it { should_not be_able_to :update, another_question }
    it { should     be_able_to :update, answer }
    it { should_not be_able_to :update, another_answer }
    
    it { should     be_able_to :destroy, question }
    it { should_not be_able_to :destroy, another_question }
    it { should     be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, another_answer }

    it { should     be_able_to :best_mark, create(:answer, question: question) }
    it { should_not be_able_to :best_mark, create(:answer, question: another_question) }

    it { should     be_able_to :rewards, User }

    it { should     be_able_to :destroy, create(:link, linkable: create(:question, user: user) ) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: another_user) ) }
    it { should     be_able_to :destroy, create(:link, linkable: create(:answer, user: user) ) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:answer, user: another_user) ) }

    it { should     be_able_to :destroy, create(:question, :with_attached_file, user: user).files.first }
    it { should_not be_able_to :destroy, create(:question, :with_attached_file, user: another_user).files.first }
    it { should     be_able_to :destroy, create(:answer, :with_attached_file, user: user).files.first }
    it { should_not be_able_to :destroy, create(:answer, :with_attached_file, user: another_user).files.first }

    it { should     be_able_to :comment, Question }
    it { should     be_able_to :comment, Answer }

    it { should     be_able_to :destroy, create(:comment, commentable: question, user: user) }
    it { should_not be_able_to :destroy, create(:comment, commentable: question, user: another_user) }

    it { should     be_able_to :destroy, create(:comment, commentable: answer, user: user) }
    it { should_not be_able_to :destroy, create(:comment, commentable: answer, user: another_user) }

    it { should     be_able_to :like, another_question }
    it { should_not be_able_to :like, question }
    it { should     be_able_to :dislike, another_answer }
    it { should_not be_able_to :dislike, answer }
  end
end
