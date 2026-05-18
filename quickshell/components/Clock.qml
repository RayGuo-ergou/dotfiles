import Quickshell.Io
import QtQuick
import "../config"

Rectangle {
  id: root
  property string displayText
  property bool showDate: false

  color: AppStyle.clockBackgroundColor
  radius: AppStyle.clockBorderRadius
  implicitWidth: clockText.implicitWidth + AppStyle.clockHorizontalPadding

  Text {
    id: clockText
    anchors.centerIn: parent
    font.pixelSize: AppStyle.clockFontPixelSize
    text: root.displayText
    color: root.showDate
      ? AppStyle.clockDateTextColor
      : AppStyle.clockTimeTextColor
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      root.showDate = !root.showDate
      dateProc.running = true
    }
  }

  Process {
    id: dateProc
    command: root.showDate
      ? ["date", "+%A, %B %-d, %Y"]
      : ["date", "+%I:%M:%S %p"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.displayText = this.text.trim()
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
