import Quickshell.Io
import Quickshell
import QtQuick
import "../config"

Rectangle {
  id: root
  property int outputPercent: 0
  property int inputPercent: 0
  property bool outputMuted: false
  property bool inputMuted: false
  property bool menuVisible: false

  color: AppStyle.volumeBackgroundColor
  radius: AppStyle.volumeBorderRadius
  implicitWidth: contentRow.implicitWidth + AppStyle.volumeHorizontalPadding

  function parseVolumeState(payload) {
    const lines = payload.trim().split("\n")
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim()
      if (line.length === 0) {
        continue
      }

      const parts = line.split(/\s+/)
      if (parts.length < 3) {
        continue
      }

      const key = parts[0]
      const pct = Number(parts[1])
      const muted = parts[2] === "1"
      if (Number.isNaN(pct)) {
        continue
      }

      if (key === "OUT") {
        root.outputPercent = pct
        root.outputMuted = muted
      } else if (key === "IN") {
        root.inputPercent = pct
        root.inputMuted = muted
      }
    }
  }

  function clampPercent(value) {
    return Math.max(0, Math.min(100, value))
  }

  function percentFromY(y, height) {
    if (height <= 0) {
      return 0
    }

    const ratio = 1 - (y / height)
    return clampPercent(Math.round(ratio * 100))
  }

  function setOutputPercent(value) {
    const pct = clampPercent(value)
    volumeCommand.command = [
      "sh",
      "-c",
      "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + pct + "% >/dev/null 2>&1; wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 >/dev/null 2>&1"
    ]
    volumeCommand.running = true
  }

  function setInputPercent(value) {
    const pct = clampPercent(value)
    volumeCommand.command = [
      "sh",
      "-c",
      "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ " + pct + "% >/dev/null 2>&1; wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 >/dev/null 2>&1"
    ]
    volumeCommand.running = true
  }

  function adjustOutputByStep(direction) {
    const delta = AppStyle.volumeWheelStepPercent * direction
    setOutputPercent(outputPercent + delta)
  }

  function handleWheel(delta) {
    if (delta > 0) {
      adjustOutputByStep(1)
    } else if (delta < 0) {
      adjustOutputByStep(-1)
    }
  }

  Row {
    id: contentRow
    anchors.centerIn: parent
    spacing: AppStyle.spacingSm

    Row {
      spacing: AppStyle.spacingXs

      Text {
        text: root.outputMuted ? AppStyle.volumeOutputMutedIcon : AppStyle.volumeOutputIcon
        font.pixelSize: AppStyle.volumeFontPixelSize
        color: root.outputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeIconColor
      }

      Text {
        text: root.outputPercent + "%"
        font.pixelSize: AppStyle.volumeFontPixelSize
        color: root.outputMuted ? AppStyle.volumeMutedTextColor : AppStyle.volumeTextColor
      }
    }

    Row {
      spacing: AppStyle.spacingXs

      Text {
        text: root.inputMuted ? AppStyle.volumeInputMutedIcon : AppStyle.volumeInputIcon
        font.pixelSize: AppStyle.volumeFontPixelSize
        color: root.inputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeIconColor
      }

      Text {
        text: root.inputPercent + "%"
        font.pixelSize: AppStyle.volumeFontPixelSize
        color: root.inputMuted ? AppStyle.volumeMutedTextColor : AppStyle.volumeTextColor
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    preventStealing: true
    scrollGestureEnabled: true
    onClicked: root.menuVisible = !root.menuVisible
    onWheel: function(wheel) {
      const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y
      root.handleWheel(delta)
      wheel.accepted = true
    }
  }

  WheelHandler {
    target: null
    onWheel: function(event) {
      const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.pixelDelta.y
      root.handleWheel(delta)
      event.accepted = true
    }
  }

  PopupWindow {
    id: clickOutsideCatcher
    parentWindow: QsWindow.window
    relativeX: 0
    relativeY: 0
    width: QsWindow.window ? QsWindow.window.width : 0
    height: QsWindow.window ? QsWindow.window.height : 0
    color: "transparent"
    visible: root.menuVisible

    MouseArea {
      anchors.fill: parent
      onClicked: root.menuVisible = false
    }
  }

  PopupWindow {
    id: volumeMenu
    parentWindow: QsWindow.window
    relativeX: Math.round(root.mapToItem(null, 0, 0).x + ((root.width - width) / 2))
    relativeY: Math.round(root.mapToItem(null, 0, root.height).y + AppStyle.volumeMenuOffsetY)
    width: AppStyle.volumeMenuWidth
    visible: root.menuVisible
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      color: AppStyle.volumeMenuBackgroundColor
      radius: AppStyle.volumeMenuRadius
    }

    implicitHeight: sliderRow.implicitHeight + AppStyle.volumeMenuSpacing * 2

    Row {
      id: sliderRow
      anchors.centerIn: parent
      spacing: AppStyle.volumeMenuSpacing

      Column {
        spacing: AppStyle.spacingXs

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.outputMuted ? AppStyle.volumeOutputMutedIcon : AppStyle.volumeOutputIcon
          font.pixelSize: AppStyle.volumeMenuIconPixelSize
          color: root.outputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeIconColor
        }

        Item {
          width: AppStyle.volumeMenuSliderWidth
          height: AppStyle.volumeMenuSliderHeight

          Rectangle {
            anchors.fill: parent
            radius: AppStyle.radiusSm
            color: AppStyle.volumeMenuSliderTrackColor
          }

          Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Math.round(parent.height * (root.outputPercent / 100))
            radius: AppStyle.radiusSm
            color: root.outputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeMenuSliderFillColor
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: root.setOutputPercent(root.percentFromY(mouse.y, parent.height))
            onPositionChanged: {
              if (pressed) {
                root.setOutputPercent(root.percentFromY(mouse.y, parent.height))
              }
            }
          }
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.outputPercent + "%"
          font.pixelSize: AppStyle.fontSizeSm
          color: root.outputMuted ? AppStyle.volumeMutedTextColor : AppStyle.volumeMenuTextColor
        }
      }

      Column {
        spacing: AppStyle.spacingXs

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.inputMuted ? AppStyle.volumeInputMutedIcon : AppStyle.volumeInputIcon
          font.pixelSize: AppStyle.volumeMenuIconPixelSize
          color: root.inputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeIconColor
        }

        Item {
          width: AppStyle.volumeMenuSliderWidth
          height: AppStyle.volumeMenuSliderHeight

          Rectangle {
            anchors.fill: parent
            radius: AppStyle.radiusSm
            color: AppStyle.volumeMenuSliderTrackColor
          }

          Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Math.round(parent.height * (root.inputPercent / 100))
            radius: AppStyle.radiusSm
            color: root.inputMuted ? AppStyle.volumeMutedIconColor : AppStyle.volumeMenuSliderFillColor
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: root.setInputPercent(root.percentFromY(mouse.y, parent.height))
            onPositionChanged: {
              if (pressed) {
                root.setInputPercent(root.percentFromY(mouse.y, parent.height))
              }
            }
          }
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.inputPercent + "%"
          font.pixelSize: AppStyle.fontSizeSm
          color: root.inputMuted ? AppStyle.volumeMutedTextColor : AppStyle.volumeMenuTextColor
        }
      }
    }
  }

  Process {
    id: volumeProc
    command: [
      "sh",
      "-c",
      "out_line=\"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)\"; in_line=\"$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)\"; out_raw=\"$(printf '%s\\n' \"$out_line\" | awk '{print $2}')\"; in_raw=\"$(printf '%s\\n' \"$in_line\" | awk '{print $2}')\"; out_pct=$(awk -v v=\"$out_raw\" 'BEGIN { if (v==\"\" || v !~ /^[0-9.]+$/) print 0; else printf \"%d\", (v*100)+0.5 }'); in_pct=$(awk -v v=\"$in_raw\" 'BEGIN { if (v==\"\" || v !~ /^[0-9.]+$/) print 0; else printf \"%d\", (v*100)+0.5 }'); out_muted=0; in_muted=0; printf '%s' \"$out_line\" | grep -q '\\[MUTED\\]' && out_muted=1; printf '%s' \"$in_line\" | grep -q '\\[MUTED\\]' && in_muted=1; printf 'OUT %s %s\\nIN %s %s\\n' \"$out_pct\" \"$out_muted\" \"$in_pct\" \"$in_muted\""
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.parseVolumeState(this.text)
    }
  }

  Process {
    id: volumeCommand
    running: false
  }

  Timer {
    interval: AppStyle.volumePollIntervalMs
    running: true
    repeat: true
    onTriggered: {
      if (!volumeProc.running) {
        volumeProc.running = true
      }
    }
  }
}
