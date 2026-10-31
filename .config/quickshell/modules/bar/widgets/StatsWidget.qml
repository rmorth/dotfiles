import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.services.system

Item {
    id: root
    implicitWidth: statsRow.implicitWidth + 8
    implicitHeight: Theme.barHeight

    Row {
        id: statsRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: "󰻠"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 2
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: SystemState.cpuUsage + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 3
            color: SystemState.cpuUsageNum > 80 ? Theme.danger : Theme.textMuted
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "󰘚"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 2
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: SystemState.memPercent + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 3
            color: SystemState.memUsageNum > 80 ? Theme.danger : Theme.textMuted
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible: SystemState.cpuTemp !== "0" && SystemState.cpuTemp !== ""
            text: "󰔏"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 2
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            visible: SystemState.cpuTemp !== "0" && SystemState.cpuTemp !== ""
            text: SystemState.cpuTemp + "°"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 3
            color: parseInt(SystemState.cpuTemp) > 80 ? Theme.danger : Theme.textMuted
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: btopProc.running = true
    }

    Process {
        id: btopProc
        command: ["alacritty", "-e", "btop"]
    }
}
