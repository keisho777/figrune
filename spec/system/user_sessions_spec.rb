require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:user) { create(:user) }
  let!(:password) { 'password' }
  let!(:authentication) { create(:authentication, user: user) }

  describe 'ログイン前' do
    context '入力値が正常' do
      it 'ログイン処理が成功する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: password
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
        expect(page).to have_current_path(home_path)
      end
    end

    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: password
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'LINEログイン' do
      context '認証成功' do
        before do
          line_mock
        end
        it 'ログイン処理が成功する' do
          visit new_user_session_path
          click_button 'LINEでログイン'
          expect(page).to have_content 'ログインしました'
          expect(page).to have_current_path(home_path)
          auth = Authentication.last
          expect(auth.provider).to eq 'line'
          expect(auth.uid).to eq '123456'
          expect(User.count).to eq 1
          expect(Authentication.count).to eq 1
        end
      end

      context '認証失敗' do
        before do
          line_invalid_mock
        end
        it 'ログイン処理が失敗する' do
          visit new_user_session_path
          click_button 'LINEでログイン'
          expect(page).to have_content 'Line アカウントによる認証に失敗しました。理由：（Invalid credentails）'
          expect(page).to have_current_path(new_user_session_path)
          expect(Authentication.count).to eq 1
          expect(User.count).to eq 1
        end
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        login_as(user, scope: :user)
        visit home_path
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(page).to have_current_path(root_path)
      end
    end
  end
  describe '画面遷移の確認' do
    it '新規登録ページへ遷移する' do
      visit new_user_session_path
      click_link 'まだアカウントをお持ちでない方はこちら'
      expect(page).to have_current_path(new_user_registration_path)
    end

    it 'パスワード再設定ページへ遷移する' do
      visit new_user_session_path
      click_link 'パスワードをお忘れの方はこちら'
      expect(page).to have_current_path(new_user_password_path)
    end
  end
end
