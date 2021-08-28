require 'rails_helper'

RSpec.describe "Postモデルのテスト", type: :model do
  describe 'バリデーションテスト' do
    #before do
      #@post = FactoryBot.build(:post)
    #end
    subject { post.valid? }

    let(:post) { build(:post) }

    it "contentが空だと投稿できない" do
      post.content = ''
      is_expected.to eq false
    end

  end
end
