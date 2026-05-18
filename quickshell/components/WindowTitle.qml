import Quickshell.Io
import QtQuick
import "../config"

Rectangle {
  id: root
  property string titleText: "Desktop"

  color: AppStyle.clockBackgroundColor
  radius: AppStyle.clockBorderRadius
  width: Math.max(
    AppStyle.windowTitleMinWidth,
    Math.min(
      AppStyle.windowTitleMaxWidth,
      titleLabel.implicitWidth + AppStyle.clockHorizontalPadding
    )
  )

  Text {
    id: titleLabel
    anchors.centerIn: parent
    width: root.width - AppStyle.clockHorizontalPadding
    font.pixelSize: AppStyle.clockFontPixelSize
    text: root.titleText
    color: AppStyle.windowTitleTextColor
    elide: Text.ElideRight
    horizontalAlignment: Text.AlignHCenter
  }

  Process {
    id: titleProc
    command: [
      "sh",
      "-c",
      "hyprctl activewindow 2>/dev/null | sed -n 's/^\\s*title: //p' | head -n 1"
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const parsedTitle = this.text.trim()
        root.titleText = parsedTitle.length > 0 ? parsedTitle : "Desktop"
      }
    }
  }

  Timer {
    interval: AppStyle.windowTitlePollIntervalMs
    running: true
    repeat: true
    onTriggered: {
      if (!titleProc.running) {
        titleProc.running = true
      }
    }
  }
}
