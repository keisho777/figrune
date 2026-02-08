import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to"]

  // コントローラーが接続されたときに実行
  connect() {
    this.updateToConstraints()
  }

  // fromが変更されたときに実行
  updateFromDate() {
    this.updateToConstraints()
  }

  updateToConstraints() {
    const maxMonthsValue = 12
    if (!this.fromTarget.value) return
    
    this.toTarget.min = this.fromTarget.value
    
    // 終了日(to)を開始日(from)から12ヶ月後までしか選べないように設定
    const maxDate = new Date(this.fromTarget.value + '-01')
    maxDate.setMonth(maxDate.getMonth() + maxMonthsValue - 1)
    this.toTarget.max = maxDate.toISOString().slice(0, 7)

    // 開始日(from)を終了日(to)より12か月を超えて設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
    if (this.toTarget.value > this.toTarget.max) {
      this.toTarget.value = this.toTarget.max
    }
    // 開始日(from)を終了日(to)より後の値で設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
    if (this.toTarget.min > this.toTarget.value) {
      this.toTarget.value = this.toTarget.max
    }
  }
}