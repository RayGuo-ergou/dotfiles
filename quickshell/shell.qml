import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // Theme
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property string fontFamily: "FiraCode Nerd Font"
    property int fontSize: 24

    // System data
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // CPU reader — reads /proc/stat
    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (!data.startsWith("cpu "))
                    return;
                const parts = data.trim().split(/\s+/);
                const user = parseInt(parts[1]);
                const nice = parseInt(parts[2]);
                const system = parseInt(parts[3]);
                const idle = parseInt(parts[4]);
                const iowait = parseInt(parts[5]);
                const irq = parseInt(parts[6]);
                const sirq = parseInt(parts[7]);

                const totalIdle = idle + iowait;
                const total = user + nice + system + idle + iowait + irq + sirq;

                const diffIdle = totalIdle - root.lastCpuIdle;
                const diffTotal = total - root.lastCpuTotal;

                if (diffTotal > 0)
                    root.cpuUsage = Math.round((1 - diffIdle / diffTotal) * 100);

                root.lastCpuIdle = totalIdle;
                root.lastCpuTotal = total;
            }
        }
    }

    // Memory reader — reads /proc/meminfo
    Process {
        id: memProc
        command: ["cat", "/proc/meminfo"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                // pick out MemTotal and MemAvailable
                if (data.startsWith("MemTotal:")) {
                    root._memTotal = parseInt(data.split(/\s+/)[1]);
                } else if (data.startsWith("MemAvailable:")) {
                    const avail = parseInt(data.split(/\s+/)[1]);
                    if (root._memTotal > 0)
                        root.memUsage = Math.round((1 - avail / root._memTotal) * 100);
                }
            }
        }
    }

    // scratch property used while parsing meminfo
    property int _memTotal: 0

    // Poll every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
        }
    }

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 45
    color: root.colBg

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Workspaces
        Repeater {
            model: 9
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                text: index + 1
                color: isActive ? root.colCyan : (ws ? root.colBlue : root.colMuted)
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // CPU
        Text {
            text: "CPU: " + root.cpuUsage + "%"
            color: root.colYellow
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }

        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        // Memory
        Text {
            text: "Mem: " + root.memUsage + "%"
            color: root.colCyan
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }

        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        // Clock
        Text {
            id: clock
            color: root.colBlue
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
            text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            }
        }
    }
}
