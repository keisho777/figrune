require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  describe 'ユーザー新規登録' do
    let(:user) { build(:user) }
    let(:password) { 'password' }

    context '入力値が正常' do
      it 'ユーザーの新規登録が成功する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: password
        fill_in 'パスワード（確認）', with: password
        click_button '登録する'
        expect(page).to have_content 'アカウント登録が完了しました。'
        expect(page).to have_current_path(home_path)
      end
    end

    context 'メールアドレスが空白' do
      it '新規登録が失敗する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: password
        fill_in 'パスワード（確認）', with: password
        click_button '登録する'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end

    context '既存アカウントとのメールアドレス重複' do
      let(:exising_user) { create(:user) }
      it '新規登録が失敗する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: exising_user.email
        fill_in 'パスワード', with: password
        fill_in 'パスワード（確認）', with: password
        click_button '登録する'
        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end

    context 'パスワードが空白' do
      it '新規登録が失敗する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認）', with: ''
        click_button '登録する'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end

    context 'パスワードが6文字未満' do
      it '新規登録が失敗する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '1234'
        fill_in 'パスワード（確認）', with: '1234'
        click_button '登録する'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end

    context 'パスワードとパスワード（確認）が不一致' do
      it '新規登録が失敗する' do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '123456'
        fill_in 'パスワード（確認）', with: '654321'
        click_button '登録する'
        expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end
  end
  describe '画面遷移の確認' do
    it 'ログインページへ遷移する' do
      visit new_user_registration_path
      click_link 'すでにアカウントをお持ちの方はこちら'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
