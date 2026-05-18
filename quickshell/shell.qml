// Bar.qml
import Quickshell
import QtQuick
import "config"
import "components"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: AppStyle.barHeight

            Rectangle {
                anchors.fill: parent
                color: AppStyle.barBackgroundColor
            }

            Item {
                anchors.fill: parent
                anchors.margins: AppStyle.barPadding

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    spacing: AppStyle.spacingSm

                    Workspaces {
                        height: parent.height
                        monitorName: modelData.name
                    }

                    Media {
                        height: parent.height
                    }
                }

                WindowTitle {
                    anchors.centerIn: parent
                    height: parent.height
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    spacing: AppStyle.spacingSm

                    Volume {
                        height: parent.height
                    }

                    Clock {
                        height: parent.height
                    }
                }
            }
        }
    }
}
