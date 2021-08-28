require 'rails_helper'

RSpec.describe "Userモデルのテスト", type: :model do
  describe 'バリデーションテスト' do
    #before do
      #@user = FactoryBot.build(:user)
    #end
    subject { user.valid? }

    #let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    it "nicknameが空だと登録できない" do
      user.nickname = ''
      is_expected.to eq false
    end

    it "emailが空だと登録できない" do
      user.email = ''
      is_expected.to eq false
    end

    it "passwordが空だと登録できない" do
      user.password = ''
      is_expected.to eq false
    end


  end
end
