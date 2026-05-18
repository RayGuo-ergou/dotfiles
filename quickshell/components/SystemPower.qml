import Quickshell.Io
import Quickshell
import QtQuick
import "../config"

Rectangle {
  id: root
  property bool menuVisible: false

  color: AppStyle.systemPowerBackgroundColor
  radius: AppStyle.systemPowerBorderRadius
  implicitWidth: iconText.implicitWidth + AppStyle.systemPowerHorizontalPadding

  Text {
    id: iconText
    anchors.centerIn: parent
    text: "⏻"
    font.pixelSize: AppStyle.systemPowerFontPixelSize
    color: AppStyle.systemPowerIconColor
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      root.menuVisible = !root.menuVisible
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
    id: powerMenu
    parentWindow: QsWindow.window
    relativeX: QsWindow.window ? (QsWindow.window.width - width) : 0
    relativeY: Math.round(root.y + root.height + AppStyle.systemPowerMenuOffsetY)
    width: AppStyle.systemPowerMenuWidth
    visible: root.menuVisible
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      color: AppStyle.systemPowerMenuBackgroundColor
      radius: AppStyle.systemPowerMenuRadius
    }

    implicitHeight: menuColumn.implicitHeight + AppStyle.systemPowerMenuSpacing * 2

    Column {
      id: menuColumn
      anchors.fill: parent
      anchors.margins: AppStyle.systemPowerMenuSpacing
      spacing: AppStyle.systemPowerMenuSpacing

      PowerMenuItem {
        label: "Suspend"
        onClicked: root.runPowerCommand(["systemctl", "suspend"])
      }

      PowerMenuItem {
        label: "Restart"
        onClicked: root.runPowerCommand(["systemctl", "reboot"])
      }

      PowerMenuItem {
        label: "Power Off"
        onClicked: root.runPowerCommand(["systemctl", "poweroff"])
      }

      Rectangle {
        width: parent.width
        height: 1
        color: AppStyle.systemPowerMenuSeparatorColor
      }

      PowerMenuItem {
        label: "Lock Screen"
        onClicked: root.runPowerCommand(["hyprlock"])
      }

      PowerMenuItem {
        label: "Log Out"
        onClicked: root.runPowerCommand(["hyprctl", "dispatch", "exit"])
      }
    }
  }

  component PowerMenuItem: Rectangle {
    required property string label
    signal clicked

    width: parent ? parent.width : 0
    height: AppStyle.systemPowerMenuItemHeight
    radius: AppStyle.radiusSm
    color: itemMouse.containsMouse ? AppStyle.systemPowerMenuHoverColor : "transparent"

    Text {
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: AppStyle.systemPowerMenuItemHorizontalPadding
      text: parent.label
      font.pixelSize: AppStyle.fontSizeSm
      color: AppStyle.systemPowerMenuTextColor
    }

    MouseArea {
      id: itemMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: parent.clicked()
    }
  }

  function runPowerCommand(cmd) {
    powerCommand.command = cmd
    powerCommand.running = true
    root.menuVisible = false
  }

  Process {
    id: powerCommand
    running: false
  }
}
