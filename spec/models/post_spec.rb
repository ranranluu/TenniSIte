require 'rails_helper'

RSpec.describe "Postモデルのテスト", type: :model do
  describe '#create' do
    before do
      @post = FactoryBot.build(:post)
    end

    it "contentが空だと登録できない" do
      @post.content = nil
      @post.valid?
      expect(@post.errors.full_messages).to include("Content can't be blank")
    end
  end
end
