import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = {
    labels: Array,
    unpaidData: Array,
    quantityData: Array
  }
  connect() {
    const isMobile = window.innerWidth < 768
    this.chart = new Chart(this.element, {
      // 棒グラフの指定
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: "未払いの合計",
          data: this.unpaidDataValue,
          yAxisID: "y1"
        },
        {
          label: "個数",
          data: this.quantityDataValue,
          yAxisID: "y2"
        }]
      },
      options: {
        // canvasのCSSの高さに従わせる
        maintainAspectRatio: false, 
        animation: false,
        scales: {
          // 下：月ラベル
          x: {
            ticks: {
              // ラベルの文字の大きさの調整
              font: { size: isMobile ? 8 : 12 }
            }
          },
          // 左：金額ラベル
          y1: {
            ticks: {
              // ラベルの文字の大きさの調整
              font: { size: isMobile ? 8 : 12 }
            }
          },
          // 右：個数ラベル
          y2: {
            ticks: {
              // ラベルの文字の大きさの調整
              font: { size: isMobile ? 8 : 12 },
              // 整数刻みにする
              stepSize: 1
            },
            // ラベルをグラフの右に配置
            position: "right",
            // 個数のY軸グラフの横線を表示しない
            grid: {
              drawOnChartArea: false
            }
          }
        }
      }
    })
  }
}