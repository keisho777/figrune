// import { Controller } from "@hotwired/stimulus";

// import flatpickr from "flatpickr";

// // Connects to data-controller="flatpickr"
// export default class extends Controller {
// 	connect() {
// 		flatpickr(".datetime", {
// 			enableTime: true,
// 			locale: "ja",
// 			defaultHour: 0,
// 			altInput: true,
// 			altFormat: "Y/m/d H:i",
// 		});

// 		flatpickr(".date", {
// 			locale: "ja",
// 			altInput: true,
// 			altFormat: "Y/m/d",
// 		});

// 		flatpickr(".fp_date");
// 	}
// }
import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import { Japanese } from "flatpickr/dist/l10n/ja.js";
import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect";
import "flatpickr/dist/plugins/monthSelect/style.css";

export default class extends Controller {
  static targets = ["from", "to"]
  
  connect() {
    console.log(this.fromTarget.value);
    this.fromPicker = flatpickr(this.fromTarget, {
      disableMobile: true,
      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m",
          altFormat: "Y年m月",
        }),
      ],
      altInput: true,
      locale: Japanese,

    onChange: (selectedDates) => {
      console.log(this.fromTarget.value + "onchange");
      console.log(selectedDates[0]);
      console.log(this.toPicker.input.value);
      console.log(this.toPicker.config.maxDate);
        // const fromDate = selectedDates[0];
        // if (!fromDate) return;

        // // to の選択可能範囲
        // this.toPicker.set("minDate", fromDate);
        
        const maxDate = new Date(selectedDates[0]);
        maxDate.setMonth(maxDate.getMonth() + 11);
        this.toPicker.set("maxDate", maxDate);
        this.toPicker.setDate(maxDate);
      console.log(this.toPicker.input.value);
      console.log(this.toPicker.config.maxDate);
this.toPicker.destroy();

this.toPicker = flatpickr(this.toTarget, {
  disableMobile: true,
      minDate: this.fromTarget.value,
      maxDate: (() => {
        const maxDate = new Date(this.fromTarget.value + "-01");
        maxDate.setMonth(maxDate.getMonth() + 11);
        return maxDate;
      })(),

  plugins: [
    new monthSelectPlugin({
      shorthand: true,
      dateFormat: "Y-m",
      altFormat: "Y年m月",
    }),
  ],

  altInput: true,
  locale: Japanese
});
        // this.toPicker.set("maxDate", maxDate);

        // // 現在の to を取得
        // const currentTo = this.toPicker.selectedDates[0];

        // // to が maxDate を超えていたら自動補正
        // if (currentTo && currentTo > maxDate) {
        //     this.toPicker.setDate(maxDate, true);
        // }

        // // to が from より前なら from に合わせる
        // if (currentTo && currentTo < fromDate) {
        //     this.toPicker.setDate(fromDate, true);
        // }
      }
    });

    this.toPicker = flatpickr(this.toTarget, {
      disableMobile: true,
      minDate: this.fromTarget.value,
      maxDate: (() => {
        const maxDate = new Date(this.fromTarget.value + "-01");
        maxDate.setMonth(maxDate.getMonth() + 11);
        return maxDate;
      })(),
      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m",
          altFormat: "Y年m月",
        }),
      ],
      altInput: true,
      locale: Japanese,

    // onOpen: (selectedDates) => {
    //     const fromDate = selectedDates[0];
    //     if (!fromDate) return;

    //     // to の選択可能範囲
    //     // this.toPicker.set("minDate", fromDate);
        
    //     const maxDate = new Date(fromDate);
    //     maxDate.setMonth(maxDate.getMonth());
    //     this.toPicker.set("maxDate", maxDate);

    //     // this.toPicker.set("maxDate", maxDate);

    //     // // 現在の to を取得
    //     // const currentTo = this.toPicker.selectedDates[0];

    //     // // to が maxDate を超えていたら自動補正
    //     // if (currentTo && currentTo > maxDate) {
    //     //     this.toPicker.setDate(maxDate, true);
    //     // }

    //     // // to が from より前なら from に合わせる
    //     // if (currentTo && currentTo < fromDate) {
    //     //     this.toPicker.setDate(fromDate, true);
    //     // }
    //   }
    });
  }

//   updateFromDate() {
//     this.updateToConstraints()
//   }

//   updateToConstraints() {
//     const maxMonthsValue = 12
//     if (!this.fromTarget.value) return
    
//     this.toTarget.min = this.fromTarget.value
    
//     // 終了日(to)を開始日(from)から12ヶ月後までしか選べないように設定
//     const maxDate = new Date(this.fromTarget.value + '-01')
//     maxDate.setMonth(maxDate.getMonth() + maxMonthsValue - 1)
//     this.toTarget.max = maxDate.toISOString().slice(0, 7)

//     // 開始日(from)を終了日(to)より12か月を超えて設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
//     if (this.toTarget.value > this.toTarget.max) {
//       this.toTarget.value = this.toTarget.max
//     }
//     // 開始日(from)を終了日(to)より後の値で設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
//     if (this.toTarget.min > this.toTarget.value) {
//       this.toTarget.value = this.toTarget.max
//     }
//   }
}

// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["from", "to"]

//   // コントローラーが接続されたときに実行
//   connect() {
//     this.updateToConstraints()
//   }

//   // fromが変更されたときに実行
//   updateFromDate() {
//     this.updateToConstraints()
//   }

//   updateToConstraints() {
//     const maxMonthsValue = 12
//     if (!this.fromTarget.value) return
    
//     this.toTarget.min = this.fromTarget.value
    
//     // 終了日(to)を開始日(from)から12ヶ月後までしか選べないように設定
//     const maxDate = new Date(this.fromTarget.value + '-01')
//     maxDate.setMonth(maxDate.getMonth() + maxMonthsValue - 1)
//     this.toTarget.max = maxDate.toISOString().slice(0, 7)

//     // 開始日(from)を終了日(to)より12か月を超えて設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
//     if (this.toTarget.value > this.toTarget.max) {
//       this.toTarget.value = this.toTarget.max
//     }
//     // 開始日(from)を終了日(to)より後の値で設定したなら、開始日(from)から選択可能な最大値を終了日(to)に設定する
//     if (this.toTarget.min > this.toTarget.value) {
//       this.toTarget.value = this.toTarget.max
//     }
//   }
// }