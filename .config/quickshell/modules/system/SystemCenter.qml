pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services.system

FocusScope {
    id: root
    implicitWidth: 780
    implicitHeight: content.implicitHeight + 36
    focus: true

    readonly property int pfs: Theme.popupFontSize
    signal dismissed

    Keys.onPressed: event => {
        if (event.key === Qt.Key_L) {
            root.dismissed(); SystemState.lock();
            event.accepted = true;
        } else if (event.key === Qt.Key_E) {
            root.dismissed(); SystemState.logout();
            event.accepted = true;
        } else if (event.key === Qt.Key_S && (event.modifiers & Qt.ControlModifier)) {
            root.dismissed(); SystemState.shutdown();
            event.accepted = true;
        } else if (event.key === Qt.Key_S) {
            root.dismissed(); SystemState.suspend();
            event.accepted = true;
        } else if (event.key === Qt.Key_H) {
            root.dismissed(); SystemState.hibernate();
            event.accepted = true;
        } else if (event.key === Qt.Key_R) {
            root.dismissed(); SystemState.reboot();
            event.accepted = true;
        }
    }
    Keys.onEscapePressed: dismissed()

    Rectangle {
        anchors.fill: parent
        color: Theme.surface
        border.color: Theme.border
        border.width: 1
        radius: 4
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        Text {
            text: "System"
            font.family: Theme.fontFamily
            font.pixelSize: pfs + 4
            font.bold: true
            color: Theme.textBright
        }

        // System info
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 16
            rowSpacing: 6

            InfoRow { icon: "󰌢"; label: "Host"; value: SystemState.hostname }
            InfoRow { icon: "󰥔"; label: "Uptime"; value: SystemState.uptime }
            InfoRow { icon: "󰌽"; label: "Kernel"; value: SystemState.kernel }
            InfoRow { icon: "󰻠"; label: "CPU"; value: SystemState.cpu }
            InfoRow { icon: "󰍛"; label: "Usage"; value: SystemState.cpuUsage + "%" + (SystemState.cpuTemp !== "0" ? "  " + SystemState.cpuTemp + "°C" : "") }
            InfoRow { icon: "󰘚"; label: "RAM"; value: SystemState.memUsed + " / " + SystemState.memTotal + " MiB (" + SystemState.memPercent + "%)" }
            InfoRow { icon: "󰋊"; label: "Disk"; value: SystemState.disk }
            InfoRow { icon: "󰈀"; label: "IP"; value: SystemState.ipAddr }
            InfoRow { icon: "󰆍"; label: "Shell"; value: SystemState.shell }
            InfoRow { icon: "󰏖"; label: "Packages"; value: SystemState.packages }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

        // Power actions
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            PowerButton { key: "l"; label: "Lock"; icon: "󰌾"; onActivated: { root.dismissed(); SystemState.lock(); } }
            PowerButton { key: "e"; label: "Logout"; icon: "󰍃"; onActivated: { root.dismissed(); SystemState.logout(); } }
            PowerButton { key: "s"; label: "Suspend"; icon: "󰒲"; onActivated: { root.dismissed(); SystemState.suspend(); } }
            PowerButton { key: "h"; label: "Hibernate"; icon: "󰤄"; onActivated: { root.dismissed(); SystemState.hibernate(); } }
            PowerButton { key: "r"; label: "Reboot"; icon: "󰜉"; onActivated: { root.dismissed(); SystemState.reboot(); } }
            PowerButton { key: "Ctrl+s"; label: "Shutdown"; icon: "󰐥"; onActivated: { root.dismissed(); SystemState.shutdown(); } }
        }
    }

    component InfoRow: RowLayout {
        property string icon
        property string label
        property string value
        Layout.fillWidth: true
        spacing: 10
        Text {
            text: icon
            font.family: Theme.fontFamily
            font.pixelSize: root.pfs + 2
            color: Theme.accent
            Layout.preferredWidth: root.pfs + 6
        }
        Text {
            text: label
            font.family: Theme.fontFamily
            font.pixelSize: root.pfs
            font.bold: true
            color: Theme.textBright
            Layout.preferredWidth: 100
        }
        Text {
            Layout.fillWidth: true
            text: value
            font.family: Theme.fontFamily
            font.pixelSize: root.pfs
            color: Theme.textMuted
            elide: Text.ElideRight
        }
    }

    component PowerButton: Rectangle {
        property string key
        property string label
        property string icon
        signal activated

        Layout.fillWidth: true
        implicitHeight: btnCol.implicitHeight + 16
        radius: 4
        color: btnMouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15) : "transparent"
        border.width: 1
        border.color: btnMouse.containsMouse ? Theme.accent : Theme.border

        ColumnLayout {
            id: btnCol
            anchors.centerIn: parent
            spacing: 3
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: icon
                font.family: Theme.fontFamily
                font.pixelSize: root.pfs + 6
                color: Theme.textBright
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: label
                font.family: Theme.fontFamily
                font.pixelSize: root.pfs - 2
                color: Theme.textMuted
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "(" + key + ")"
                font.family: Theme.fontFamily
                font.pixelSize: root.pfs - 3
                color: Theme.textMuted
            }
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: activated()
        }
    }
}
