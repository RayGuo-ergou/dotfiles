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
    volumeCommand.command = ["sh", AppStyle.scriptsDir + "volume-set-output.sh", pct.toString()]
    volumeCommand.running = true
  }

  function setInputPercent(value) {
    const pct = clampPercent(value)
    volumeCommand.command = ["sh", AppStyle.scriptsDir + "volume-set-input.sh", pct.toString()]
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
    anchor.window: QsWindow.window
    anchor.rect.x: 0
    anchor.rect.y: 0
    implicitWidth: QsWindow.window ? QsWindow.window.width : 0
    implicitHeight: QsWindow.window ? QsWindow.window.height : 0
    color: "transparent"
    visible: root.menuVisible

    MouseArea {
      anchors.fill: parent
      onClicked: root.menuVisible = false
    }
  }

  PopupWindow {
    id: volumeMenu
    anchor.window: QsWindow.window
    anchor.rect.x: Math.round(root.mapToItem(null, 0, 0).x + ((root.width - width) / 2))
    anchor.rect.y: Math.round(root.mapToItem(null, 0, root.height).y + AppStyle.volumeMenuOffsetY)
    implicitWidth: AppStyle.volumeMenuWidth
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
            onPressed: function(mouse) { root.setOutputPercent(root.percentFromY(mouse.y, parent.height)) }
            onPositionChanged: function(mouse) {
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
            onPressed: function(mouse) { root.setInputPercent(root.percentFromY(mouse.y, parent.height)) }
            onPositionChanged: function(mouse) {
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
    command: ["sh", AppStyle.scriptsDir + "volume-status.sh"]
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
