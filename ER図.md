### ER図
<img width="1161" height="612" alt="image" src="https://github.com/user-attachments/assets/5820e77f-0105-4cb5-906d-1c458aaa9bd9" />

### 本サービスの概要（700文字以内）
※ あなたが作成するアプリの目的・概要・想定ユーザー・主な機能などを700文字以内でまとめてください。
「どんな課題を解決するのか」「誰がどのように使うのか」が伝わる内容にしましょう。

### MVPで実装する予定の機能
※ この項目では、MVP（Minimum Viable Product：最小限の実用的な製品）として実装予定の機能を箇条書きで整理してください。

### テーブル詳細
#### Usersテーブル（ユーザー情報）
- email : ログイン認証用のメールアドレス（例：taro@example.com） / ユニーク制約 / NOTNULL制約
- encrypted_password : 暗号化されたパスワード（Deviseが自動管理）/ NOTNULL制約
- reset_password_token : パスワード再設定用トークン（Deviseが自動生成）
- reset_password_sent_at : パスワード再設定メール送信日時
- remember_created_at : ログイン状態保持を開始した日時
- confirmation_token : メールアドレス確認用トークン（Confirmable使用時）
- confirmed_at : メールアドレス確認完了日時
- confirmation_sent_at : 確認メール送信日時
- unconfirmed_email : メールアドレス変更時の未確認メールアドレス
- provider :　プロバイダー名（例：line）
- uid : プロバイダー側のユーザー識別ID
- created_at : 作成日時
- updated_at : 更新日時

#### Figuresテーブル（フィギュア情報）
- user_id : ユーザーテーブルの外部キー / 外部キー制約
- manufacture_id : メーカーテーブルの外部キー / 外部キー制約
- title_id : 作品名テーブルの外部キー / 外部キー制約
- shop_id : 購入・予約店舗テーブルの外部キー / 外部キー制約
- name : 商品名（例：POP UP PARADE 星のカービィ カービィ ウィリーライダーVer. 完成品フィギュア）/ NOTNULL制約
- release_month : 販売月（例：2026年1月）/ NOTNULL制約
- quantity : 個数（例：1）/ NOTNULL制約
- price : 金額（例：1000）/ NOTNULL制約
- payment_status : 支払い済み/未払いのステータス（例：0（enumでの実装予定のため））/ NOTNULL制約
- width_cm : 大きさの横幅（例：30）
- height_cm : 大きさの高さ（例：40）
- depth_cm : 大きさの奥行（例：10）
- note : 備考（例：支払いには注意すること）
- created_at : 作成日時
- updated_at : 更新日時

#### Manufacturesテーブル（メーカー情報）
- name : メーカー名（例：グッドスマイルカンパニー）
- created_at : 作成日時
- updated_at : 更新日時

#### Titlesテーブル（作品情報）
- name : 作品名（例：ワンピース）
- created_at : 作成日時
- updated_at : 更新日時

#### Shopsテーブル（購入・予約店舗情報）
- name : 購入・予約店舗名（例：Amazon）
- created_at : 作成日時
- updated_at : 更新日時

### ER図の注意点
- [x] プルリクエストに最新のER図のスクリーンショットを画像が表示される形で掲載できているか？
- [x] テーブル名は複数形になっているか？
- [x] カラムの型は記載されているか？
- [x] 外部キーは適切に設けられているか？
- [x] リレーションは適切に描かれているか？多対多の関係は存在しないか？
- [x] STIは使用しないER図になっているか？
- [x] Postsテーブルにpost_nameのように"テーブル名+カラム名"を付けていないか？
