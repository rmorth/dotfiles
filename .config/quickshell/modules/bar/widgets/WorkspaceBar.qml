import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config

Item {
    id: root
    implicitWidth: wsRow.implicitWidth
    implicitHeight: Theme.barHeight
    Layout.alignment: Qt.AlignVCenter

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: wheel => {
            const direction = wheel.angleDelta.y > 0 ? "workspace e-1" : "workspace e+1"
            Hyprland.dispatch(direction)
        }
    }

    Row {
        id: wsRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                id: wsButton
                required property var modelData

                readonly property bool active: modelData.focused
                readonly property bool occupied: modelData.toplevels.values.length > 0
                readonly property bool isSpecial: modelData.id < 0

                visible: !isSpecial
                width: wsText.implicitWidth + 16
                height: Theme.barHeight - 8
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                radius: 2
                color: active ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2) : "transparent"

                Text {
                    id: wsText
                    anchors.centerIn: parent
                    text: modelData.name || String(modelData.id)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: active
                    color: active ? Theme.accent : occupied ? Theme.wsOccupied : Theme.wsEmpty
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
