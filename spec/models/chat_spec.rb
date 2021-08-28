require 'rails_helper'

RSpec.describe "Chatモデルのテスト", type: :model do
  describe 'バリデーションテスト' do

    subject { chat.valid? }

    let(:chat) { build(:chat) }

    it "messageが空だとチャットを送れない" do
      chat.message = ''
      is_expected.to eq false
    end

  end
end