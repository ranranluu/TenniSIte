require 'rails_helper'

RSpec.describe "PostCommentモデルのテスト", type: :model do
  describe 'バリデーションテスト' do

    subject { post_comment.valid? }

    let(:post_comment) { build(:post_comment) }

    it "commentが空だとコメントできない" do
      post_comment.comment = ''
      is_expected.to eq false
    end

  end
end