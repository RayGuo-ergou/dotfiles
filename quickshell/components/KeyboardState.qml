import Quickshell.Io
import QtQuick
import "../config"

Rectangle {
  id: root
  property bool capsOn: false
  property bool numOn: false

  color: AppStyle.keyboardBackgroundColor
  radius: AppStyle.keyboardBorderRadius
  implicitWidth: stateRow.implicitWidth + AppStyle.keyboardHorizontalPadding

  function updateStates(payload) {
    const tokens = payload.trim().split(/\s+/)
    if (tokens.length < 2) {
      return
    }

    root.capsOn = tokens[0] === "on"
    root.numOn = tokens[1] === "on"
  }

  Row {
    id: stateRow
    anchors.centerIn: parent
    spacing: AppStyle.spacingXs

    Text {
      text: "CAPS"
      font.pixelSize: AppStyle.keyboardFontPixelSize
      color: root.capsOn ? AppStyle.keyboardOnTextColor : AppStyle.keyboardOffTextColor
    }

    Text {
      text: "NUM"
      font.pixelSize: AppStyle.keyboardFontPixelSize
      color: root.numOn ? AppStyle.keyboardOnTextColor : AppStyle.keyboardOffTextColor
    }
  }

  Process {
    id: stateProc
    command: [
      "sh",
      "-c",
      "caps=off; num=off; for f in /sys/class/leds/*::capslock/brightness; do if [ -f \"$f\" ]; then [ \"$(cat \"$f\" 2>/dev/null)\" = \"1\" ] && caps=on; break; fi; done; for f in /sys/class/leds/*::numlock/brightness; do if [ -f \"$f\" ]; then [ \"$(cat \"$f\" 2>/dev/null)\" = \"1\" ] && num=on; break; fi; done; printf '%s %s\\n' \"$caps\" \"$num\""
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.updateStates(this.text)
    }
  }

  Timer {
    interval: AppStyle.keyboardPollIntervalMs
    running: true
    repeat: true
    onTriggered: {
      if (!stateProc.running) {
        stateProc.running = true
      }
    }
  }
}
