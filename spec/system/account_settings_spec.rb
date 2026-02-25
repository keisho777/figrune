require 'rails_helper'

RSpec.describe "AccountSettings", type: :system do
  let(:user) { create(:user) }
  describe 'ログイン前' do
    before { visit root_path }
    context 'ページ遷移確認' do
      it 'アカウント設定画面へのアクセスに失敗する' do
        visit account_setting_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq new_user_session_path
      end

      it 'メールアドレス変更画面へのアクセスに失敗する' do
        visit edit_email_account_setting_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq new_user_session_path
      end

      it 'パスワード変更画面へのアクセスに失敗する' do
        visit edit_password_account_setting_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user, scope: :user)
      visit account_setting_path
    end
    context 'ページ遷移確認' do
      context 'メールアドレス登録済み' do
        it 'メールアドレス変更画面にアクセスできる' do
          within('.grid', text: 'メールアドレス') do
            click_link '変更'
          end
          expect(page).to have_content('メールアドレス変更')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end

      context 'メールアドレス未登録' do
        before do
          user.update!(has_email: false)
          visit account_setting_path
        end
        it 'メールアドレス設定画面にアクセスできる' do
          within('.grid', text: 'メールアドレス') do
            click_link '設定'
          end
          expect(page).to have_content('メールアドレス設定')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end
      
      context 'パスワード登録済み' do
        it 'パスワード変更画面にアクセスできる' do
          within('.grid', text: 'パスワード') do
            click_link '変更'
          end
          expect(page).to have_content('パスワード変更')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context 'パスワード未登録' do
        before do
          user.update!(has_password: false)
          visit account_setting_path
        end
        it 'パスワード設定画面にアクセスできる' do
          within('.grid', text: 'パスワード') do
            click_link '設定'
          end
          expect(page).to have_content('パスワード設定')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end
    end

    context 'メールアドレス変更' do
      before { visit edit_email_account_setting_path }
      context '入力値が正常' do
        it 'メールアドレス変更の確認メールの送信ができる' do
          expect(page).to have_content('メールアドレス変更')
          expect(page).to have_content('現在のメールアドレス')
          expect(page).to have_content(user.email)
          fill_in '新しいメールアドレス', with: 'new_user@example.com'
          click_button '変更する'
          expect(page).to have_content('確認メールを送信しました')
          expect(page).to have_current_path(account_setting_path)
        end
      end

      context '新しいメールアドレスが未入力' do
        it 'メールアドレス変更の確認メールの送信が失敗する' do
          expect(page).to have_content('メールアドレス変更')
          expect(page).to have_content('現在のメールアドレス')
          expect(page).to have_content(user.email)
          fill_in '新しいメールアドレス', with: ''
          click_button '変更する'
          expect(page).to have_content('メールアドレスを入力してください')
          expect(page).to have_content('変更できませんでした')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end

      context '既存のメールアドレスを入力' do
        let!(:user2) { create(:user, email: 'user2@example.com') }
        it 'メールアドレス変更の確認メールの送信が失敗する' do
          expect(page).to have_content('メールアドレス変更')
          expect(page).to have_content('現在のメールアドレス')
          expect(page).to have_content(user.email)
          fill_in '新しいメールアドレス', with: 'user2@example.com'
          click_button '変更する'
          expect(page).to have_content('メールアドレスはすでに存在します')
          expect(page).to have_content('変更できませんでした')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end
    end

    context 'メールアドレス設定' do
      before do
        user.update!(has_email: false)
        visit edit_email_account_setting_path
      end
      context '入力値が正常' do
        it 'メールアドレス設定の確認メールの送信ができる' do
          expect(page).to have_content('メールアドレス設定')
          expect(page).not_to have_content('現在のメールアドレス')
          fill_in 'メールアドレス', with: 'new_user@example.com'
          click_button '設定する'
          expect(page).to have_content('確認メールを送信しました')
          expect(page).to have_current_path(account_setting_path)
        end
      end

      context 'メールアドレスが未入力' do
        it 'メールアドレス変更の確認メールの送信が失敗する' do
          expect(page).to have_content('メールアドレス設定')
          expect(page).not_to have_content('現在のメールアドレス')
          fill_in 'メールアドレス', with: ''
          click_button '設定する'
          expect(page).to have_content('メールアドレスを入力してください')
          expect(page).to have_content('設定できませんでした')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end

      context '既存のメールアドレスを入力' do
        let!(:user2) { create(:user, email: 'user2@example.com') }
        it 'メールアドレス変更の確認メールの送信が失敗する' do
          expect(page).to have_content('メールアドレス設定')
          expect(page).not_to have_content('現在のメールアドレス')
          fill_in 'メールアドレス', with: 'user2@example.com'
          click_button '設定する'
          expect(page).to have_content('メールアドレスはすでに存在します')
          expect(page).to have_content('設定できませんでした')
          expect(page).to have_current_path(edit_email_account_setting_path)
        end
      end
    end

    context 'パスワード変更' do
      before { visit edit_password_account_setting_path }
      context '入力値が正常' do
        it 'パスワード変更ができる' do
          old_pass = user.encrypted_password
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: 'password'
          fill_in '新しいパスワード', with: '123456'
          fill_in '新しいパスワード（確認）', with: '123456'
          click_button '変更する'
          expect(page).to have_content('変更しました')
          expect(page).to have_current_path(account_setting_path)
          user.reload
          expect(user.encrypted_password).not_to eq old_pass
        end
      end

      context '現在のパスワードが未入力' do
        it 'パスワード変更に失敗する' do
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: ''
          fill_in '新しいパスワード', with: '123456'
          fill_in '新しいパスワード（確認）', with: '123456'
          click_button '変更する'
          expect(page).to have_content('現在のパスワードを入力してください')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context '現在のパスワードが不正な値' do
        it 'パスワード変更に失敗する' do
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: 'aaaaaa'
          fill_in '新しいパスワード', with: '123456'
          fill_in '新しいパスワード（確認）', with: '123456'
          click_button '変更する'
          expect(page).to have_content('現在のパスワードは不正な値です')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context '新しいパスワードが未入力' do
        it 'パスワード変更に失敗する' do
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: 'password'
          fill_in '新しいパスワード', with: ''
          fill_in '新しいパスワード（確認）', with: ''
          click_button '変更する'
          expect(page).to have_content('新しいパスワードを入力してください')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context '新しいパスワードが6文字未満' do
        it 'パスワード変更に失敗する' do
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: 'password'
          fill_in '新しいパスワード', with: '12345'
          fill_in '新しいパスワード（確認）', with: '12345'
          click_button '変更する'
          expect(page).to have_content('新しいパスワードは6文字以上で入力してください')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context '新しいパスワードと新しいパスワード（確認）が不一致' do
        it 'パスワード変更に失敗する' do
          expect(page).to have_content('パスワード変更')
          fill_in '現在のパスワード', with: 'password'
          fill_in '新しいパスワード', with: '123456'
          fill_in '新しいパスワード（確認）', with: '654321'
          click_button '変更する'
          expect(page).to have_content('新しいパスワード（確認）と新しいパスワードの入力が一致しません')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end
    end

    context 'パスワード設定' do
      before do
        user.update!(has_password: false)
        visit edit_password_account_setting_path
      end
      context '入力値が正常' do
        it 'パスワード設定ができる' do
          old_pass = user.encrypted_password
          expect(page).to have_content('パスワード設定')
          expect(page).not_to have_content('現在のパスワード')
          fill_in 'パスワード', with: '123456'
          fill_in 'パスワード（確認）', with: '123456'
          click_button '設定する'
          expect(page).to have_content('設定しました')
          expect(page).to have_current_path(account_setting_path)
          user.reload
          expect(user.encrypted_password).not_to eq old_pass
          expect(user.has_password).to eq true
        end
      end

      context 'パスワードが未入力' do
        it 'パスワード設定が失敗する' do
          expect(page).to have_content('パスワード設定')
          expect(page).not_to have_content('現在のパスワード')
          fill_in 'パスワード', with: ''
          fill_in 'パスワード（確認）', with: ''
          click_button '設定する'
          expect(page).to have_content('パスワードを入力してください')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context 'パスワードが6文字未満' do
        it 'パスワード設定が失敗する' do
          expect(page).to have_content('パスワード設定')
          expect(page).not_to have_content('現在のパスワード')
          fill_in 'パスワード', with: '12345'
          fill_in 'パスワード（確認）', with: '12345'
          click_button '設定する'
          expect(page).to have_content('パスワードは6文字以上で入力してください')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end

      context 'パスワードとパスワード（確認）が不一致' do
        it 'パスワード設定が失敗する' do
          expect(page).to have_content('パスワード設定')
          expect(page).not_to have_content('現在のパスワード')
          fill_in 'パスワード', with: '123456'
          fill_in 'パスワード（確認）', with: '654321'
          click_button '設定する'
          expect(page).to have_content('パスワード（確認）とパスワードの入力が一致しません')
          expect(page).to have_current_path(edit_password_account_setting_path)
        end
      end
    end

    context '通知設定' do
      it 'メール通知の設定ができること' do
        select '1週間前', from: 'user_email_notification_timing'
        expect(page).to have_content('1週間前')
        user.reload
        expect(user.email_notification_timing).to eq 'one_week_before'
      end

      it 'LINE通知の設定ができること' do
        select '1週間前', from: 'user_line_notification_timing'
        expect(page).to have_content('1週間前')
        user.reload
        expect(user.line_notification_timing).to eq 'one_week_before'
      end
    end
  end
end
