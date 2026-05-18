import Quickshell.Io
import QtQuick
import "../config"

Rectangle {
  id: root
  property string monitorName: ""
  property int activeWorkspaceId: -1
  property bool specialHasWindows: false
  property string lastWorkspaceSignature: ""

  color: AppStyle.workspaceBackgroundColor
  radius: AppStyle.workspaceRadius
  visible: workspaceModel.count > 0 || root.specialHasWindows
  implicitWidth: workspaceRow.implicitWidth
    + AppStyle.workspaceInnerPaddingLeft
    + AppStyle.workspaceInnerPaddingRight

  function refreshWorkspaces(payload) {
    const monitorsMarker = "\n__MONITORS__\n"
    const monitorsMarkerIndex = payload.indexOf(monitorsMarker)
    if (monitorsMarkerIndex < 0) {
      return
    }

    const clientsMarker = "\n__CLIENTS__\n"
    const clientsMarkerIndex = payload.indexOf(clientsMarker)
    if (clientsMarkerIndex < 0) {
      return
    }

    const workspacesRaw = payload
      .slice(0, monitorsMarkerIndex)
      .replace(/^__WORKSPACES__\n?/, "")
      .trim()
    const monitorsRaw = payload.slice(
      monitorsMarkerIndex + monitorsMarker.length,
      clientsMarkerIndex
    ).trim()
    const clientsRaw = payload.slice(clientsMarkerIndex + clientsMarker.length).trim()

    let workspaceList = []
    let monitorList = []
    let clientList = []
    let activeId = root.activeWorkspaceId

    try {
      workspaceList = JSON.parse(workspacesRaw)
    } catch (_) {
      workspaceList = []
    }

    try {
      monitorList = JSON.parse(monitorsRaw)
    } catch (_) {
      monitorList = []
    }

    try {
      clientList = JSON.parse(clientsRaw)
    } catch (_) {
      clientList = []
    }

    const targetMonitor = monitorList.find((monitor) =>
      typeof monitor.name === "string" && monitor.name === root.monitorName)
      || monitorList.find((monitor) => monitor.focused === true)
      || null

    if (targetMonitor
      && targetMonitor.activeWorkspace
      && typeof targetMonitor.activeWorkspace.id === "number") {
      activeId = targetMonitor.activeWorkspace.id
    }

    const targetMonitorName = targetMonitor && typeof targetMonitor.name === "string"
      ? targetMonitor.name
      : ""

    root.activeWorkspaceId = activeId

    const occupiedWorkspaceIds = {}
    let hasSpecialWindows = false

    for (let i = 0; i < clientList.length; i++) {
      const client = clientList[i]
      const ws = client && client.workspace ? client.workspace : null
      if (!ws || typeof ws.id !== "number") {
        continue
      }

      const wsName = typeof ws.name === "string" ? ws.name : ""
      if (wsName.startsWith("special:")) {
        hasSpecialWindows = true
        continue
      }

      occupiedWorkspaceIds[ws.id] = true
    }

    const entries = []
    const seenWorkspaceIds = {}

    for (let i = 0; i < workspaceList.length; i++) {
      const workspace = workspaceList[i]
      if (typeof workspace.id !== "number") {
        continue
      }

      const rawName = typeof workspace.name === "string" ? workspace.name : ""
      const isSpecial = rawName.startsWith("special:")
      if (isSpecial) {
        continue
      }

      const monitorMatchesByName = targetMonitorName.length > 0 && workspace.monitor === targetMonitorName
      const monitorMatchesById = targetMonitor
        && typeof targetMonitor.id === "number"
        && typeof workspace.monitorID === "number"
        && workspace.monitorID === targetMonitor.id
      if (targetMonitor && !monitorMatchesByName && !monitorMatchesById) {
        continue
      }

      if (occupiedWorkspaceIds[workspace.id] !== true) {
        continue
      }

      if (seenWorkspaceIds[workspace.id] === true) {
        continue
      }

      const cleanedName = rawName.replace(/[^\x20-\x7E]/g, "").trim()
      const labelMatch = cleanedName.match(/([1-9]\d*)$/) || cleanedName.match(/^([1-9]\d*)/)
      const label = labelMatch
        ? labelMatch[1]
        : (cleanedName.length > 0 ? cleanedName : workspace.id.toString())

      seenWorkspaceIds[workspace.id] = true
      entries.push({
        workspaceId: workspace.id,
        label: label,
        workspaceTarget: label
      })
    }

    root.specialHasWindows = hasSpecialWindows

    entries.sort((a, b) => {
      const aNum = Number(a.label)
      const bNum = Number(b.label)
      const aIsNum = Number.isInteger(aNum)
      const bIsNum = Number.isInteger(bNum)
      if (aIsNum && bIsNum && aNum !== bNum) {
        return aNum - bNum
      }
      if (aIsNum !== bIsNum) {
        return aIsNum ? -1 : 1
      }
      return a.label.localeCompare(b.label)
    })

    const signature = entries
      .map((entry) => `${entry.workspaceId}|${entry.label}`)
      .join(";") + `|active:${root.activeWorkspaceId}|special:${root.specialHasWindows}`

    if (signature !== root.lastWorkspaceSignature) {
      workspaceModel.clear()
      for (let i = 0; i < entries.length; i++) {
        workspaceModel.append({
          workspaceId: entries[i].workspaceId,
          label: entries[i].label,
          workspaceTarget: entries[i].workspaceTarget
        })
      }
      root.lastWorkspaceSignature = signature
    }
  }

  function switchToWorkspace(localTarget, workspaceId) {
    const localTargetIsNumeric = /^[1-9]\d*$/.test(localTarget)
    if (localTargetIsNumeric) {
      switchProc.command = [
        "sh",
        "-c",
        `hyprctl dispatch focusmonitor '${root.monitorName}'; hypr-local-workspaces goto ${localTarget} --no-compact`
      ]
    } else {
      switchProc.command = ["hyprctl", "dispatch", "workspace", workspaceId.toString()]
    }
    switchProc.running = true
    pollProc.running = true
  }

  function toggleSpecialWorkspace() {
    specialProc.command = ["hyprctl", "dispatch", "togglespecialworkspace", "magic"]
    specialProc.running = true
    pollProc.running = true
  }

  Row {
    id: workspaceRow
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: AppStyle.workspaceInnerPaddingLeft
    spacing: AppStyle.workspaceButtonSpacing

    Repeater {
      model: ListModel {
        id: workspaceModel
      }

      delegate: Rectangle {
        required property int workspaceId
        required property string label
        required property string workspaceTarget
        property bool isActive: workspaceId === root.activeWorkspaceId

        color: "transparent"
        radius: AppStyle.workspaceButtonRadius
        implicitWidth: labelText.implicitWidth + AppStyle.workspaceButtonPadding * 2
        implicitHeight: root.height - AppStyle.workspaceOuterMargin * 2

        Text {
          id: labelText
          anchors.centerIn: parent
          font.pixelSize: AppStyle.workspaceFontPixelSize
          text: label
          color: parent.isActive
            ? AppStyle.workspaceActiveTextColor
            : (workspaceMouse.containsMouse
              ? AppStyle.workspaceHoverTextColor
              : AppStyle.workspaceTextColor)
        }

        MouseArea {
          id: workspaceMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.switchToWorkspace(parent.workspaceTarget, parent.workspaceId)
        }
      }
    }

    Rectangle {
      visible: root.specialHasWindows
      color: "transparent"
      radius: AppStyle.workspaceButtonRadius
      implicitWidth: specialLabel.implicitWidth + AppStyle.workspaceButtonPadding * 2
      implicitHeight: root.height - AppStyle.workspaceOuterMargin * 2

      Text {
        id: specialLabel
        anchors.centerIn: parent
        font.pixelSize: AppStyle.workspaceFontPixelSize
        text: "S"
        color: specialMouse.containsMouse
          ? AppStyle.workspaceHoverTextColor
          : AppStyle.workspaceActiveTextColor
      }

      MouseArea {
        id: specialMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggleSpecialWorkspace()
      }
    }

  }

  Process {
    id: pollProc
    command: [
      "sh",
      "-c",
      "printf '__WORKSPACES__\\n'; hyprctl workspaces -j 2>/dev/null; printf '\\n__MONITORS__\\n'; hyprctl monitors -j 2>/dev/null; printf '\\n__CLIENTS__\\n'; hyprctl clients -j 2>/dev/null"
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.refreshWorkspaces(this.text)
    }
  }

  Process {
    id: switchProc
    running: false
  }

  Process {
    id: specialProc
    running: false
  }

  Timer {
    interval: AppStyle.workspacePollIntervalMs
    running: true
    repeat: true
    onTriggered: {
      if (!pollProc.running) {
        pollProc.running = true
      }
    }
  }
}
