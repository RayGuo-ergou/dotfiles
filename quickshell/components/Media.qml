import Quickshell.Io
import Quickshell
import QtQuick
import "../config"

Rectangle {
  id: root
  property string mediaText: ""
  property string mediaStatus: ""
  property string mediaPlayer: ""
  property string mediaArtist: ""
  property string mediaTitle: ""
  property string mediaAlbum: ""
  property bool menuVisible: false

  visible: mediaText.length > 0
  onVisibleChanged: {
    if (!visible) {
      menuVisible = false
    }
  }

  color: AppStyle.mediaBackgroundColor
  radius: AppStyle.mediaBorderRadius
  implicitWidth: contentRow.implicitWidth + AppStyle.mediaHorizontalPadding

  function clearMedia() {
    mediaStatus = ""
    mediaPlayer = ""
    mediaArtist = ""
    mediaTitle = ""
    mediaAlbum = ""
    mediaText = ""
  }

  function parseMetadata(payload) {
    const raw = payload.trim()
    if (raw.length === 0) {
      clearMedia()
      return
    }

    let status = ""
    let player = ""
    let artist = ""
    let title = ""
    let album = ""

    const lines = raw.split("\n")
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim()
      if (line.length === 0) {
        continue
      }

      const splitAt = line.indexOf(" ")
      const key = splitAt === -1 ? line : line.slice(0, splitAt)
      const value = splitAt === -1 ? "" : line.slice(splitAt + 1).trim()

      if (key === "STATUS") {
        status = value
      } else if (key === "PLAYER") {
        player = value
      } else if (key === "ARTIST") {
        artist = value
      } else if (key === "TITLE") {
        title = value
      } else if (key === "ALBUM") {
        album = value
      }
    }

    if (status !== "Playing") {
      clearMedia()
      return
    }

    mediaStatus = status
    mediaPlayer = player
    mediaArtist = artist
    mediaTitle = title
    mediaAlbum = album

    if (mediaArtist.length > 0 && mediaTitle.length > 0) {
      mediaText = mediaArtist + " - " + mediaTitle
    } else if (mediaTitle.length > 0) {
      mediaText = mediaTitle
    } else if (mediaArtist.length > 0) {
      mediaText = mediaArtist
    } else {
      mediaText = mediaPlayer
    }
  }

  function runMediaCommand(args, closeMenu) {
    mediaCommand.command = args
    mediaCommand.running = true

    if (closeMenu === undefined || closeMenu) {
      menuVisible = false
    }

    if (!mediaProc.running) {
      mediaProc.running = true
    }
  }

  Row {
    id: contentRow
    anchors.centerIn: parent
    spacing: AppStyle.spacingXs

    Text {
      text: AppStyle.mediaIcon
      font.pixelSize: AppStyle.mediaFontPixelSize
      color: AppStyle.mediaIconColor
    }

    Text {
      text: root.mediaText
      font.pixelSize: AppStyle.mediaFontPixelSize
      color: AppStyle.mediaTextColor
      elide: Text.ElideRight
      maximumLineCount: 1
      width: Math.min(implicitWidth, AppStyle.mediaMaxTextWidth)
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    enabled: root.visible
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
    id: mediaMenu
    parentWindow: QsWindow.window
    relativeX: Math.round(root.x + root.width - width)
    relativeY: Math.round(root.y + root.height + AppStyle.mediaMenuOffsetY)
    width: AppStyle.mediaMenuWidth
    visible: root.menuVisible
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      color: AppStyle.mediaMenuBackgroundColor
      radius: AppStyle.mediaMenuRadius
    }

    implicitHeight: menuColumn.implicitHeight + AppStyle.mediaMenuSpacing * 2

    Column {
      id: menuColumn
      anchors.fill: parent
      anchors.margins: AppStyle.mediaMenuSpacing
      spacing: AppStyle.mediaMenuSpacing

      Rectangle {
        width: parent.width
        height: metaColumn.implicitHeight + AppStyle.mediaMenuItemVerticalPadding * 2
        radius: AppStyle.radiusSm
        color: AppStyle.mediaMenuMetaBackgroundColor

        Column {
          id: metaColumn
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.margins: AppStyle.mediaMenuItemHorizontalPadding
          spacing: AppStyle.spacingXs

          Text {
            text: root.mediaTitle.length > 0 ? root.mediaTitle : root.mediaText
            font.pixelSize: AppStyle.fontSizeSm
            color: AppStyle.mediaMenuTextColor
            elide: Text.ElideRight
            maximumLineCount: 1
          }

          Text {
            text: root.mediaArtist.length > 0 ? root.mediaArtist : root.mediaPlayer
            font.pixelSize: AppStyle.fontSizeSm - 1
            color: AppStyle.mediaMenuSubtleTextColor
            elide: Text.ElideRight
            maximumLineCount: 1
          }
        }
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: AppStyle.mediaControlButtonSpacing

        MediaControlButton {
          icon: AppStyle.mediaPreviousIcon
          onClicked: root.runMediaCommand(["playerctl", "previous"], false)
        }

        MediaControlButton {
          icon: root.mediaStatus === "Playing" ? AppStyle.mediaPauseIcon : AppStyle.mediaPlayIcon
          onClicked: root.runMediaCommand(["playerctl", "play-pause"], false)
        }

        MediaControlButton {
          icon: AppStyle.mediaStopIcon
          onClicked: root.runMediaCommand(["playerctl", "stop"])
        }

        MediaControlButton {
          icon: AppStyle.mediaNextIcon
          onClicked: root.runMediaCommand(["playerctl", "next"], false)
        }
      }
    }
  }

  component MediaControlButton: Rectangle {
    required property string icon
    signal clicked

    width: AppStyle.mediaControlButtonSize
    height: AppStyle.mediaControlButtonSize
    radius: AppStyle.radiusSm
    color: controlMouse.containsMouse ? AppStyle.mediaControlButtonHoverColor : AppStyle.mediaControlButtonColor

    Text {
      anchors.centerIn: parent
      text: parent.icon
      font.pixelSize: AppStyle.mediaControlIconPixelSize
      color: AppStyle.mediaControlIconColor
    }

    MouseArea {
      id: controlMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: parent.clicked()
    }
  }

  Process {
    id: mediaProc
    command: [
      "sh",
      "-c",
      "line=\"$(playerctl -a metadata --format '{{status}}|{{playerName}}|{{artist}}|{{title}}|{{album}}' 2>/dev/null | awk -F'|' '$1 == \"Playing\" { print; exit }')\"; [ -z \"$line\" ] && exit 0; status=\"$(printf '%s\\n' \"$line\" | cut -d'|' -f1)\"; player=\"$(printf '%s\\n' \"$line\" | cut -d'|' -f2)\"; artist=\"$(printf '%s\\n' \"$line\" | cut -d'|' -f3)\"; title=\"$(printf '%s\\n' \"$line\" | cut -d'|' -f4)\"; album=\"$(printf '%s\\n' \"$line\" | cut -d'|' -f5)\"; printf 'STATUS %s\\nPLAYER %s\\nARTIST %s\\nTITLE %s\\nALBUM %s\\n' \"$status\" \"$player\" \"$artist\" \"$title\" \"$album\""
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.parseMetadata(this.text)
    }
  }

  Process {
    id: mediaCommand
    running: false
  }

  Timer {
    interval: AppStyle.mediaPollIntervalMs
    running: true
    repeat: true
    onTriggered: {
      if (!mediaProc.running) {
        mediaProc.running = true
      }
    }
  }
}
