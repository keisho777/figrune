require 'rails_helper'

RSpec.describe Work, type: :model do
  let(:work) { build(:work) }
  describe 'バリデーションチェック' do
    it '作品名が100文字以下の場合、バリデーションエラーが起きないこと' do
      work.name = 'a' * 100
      expect(work).to be_valid
    end

    it '作品名が101文字以上の場合、バリデーションエラーが発生すること' do
      work.name = 'a' * 101
      expect(work).to be_invalid
      expect(work.errors[:name]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end
