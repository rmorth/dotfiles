pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Quickshell.Io
import qs.config
import qs.services.bluetooth

FocusScope {
    id: root
    implicitWidth: 560
    implicitHeight: content.implicitHeight + 28
    focus: true

    readonly property int pfs: Theme.popupFontSize
    property int currentIndex: 0
    signal dismissed

    readonly property var allDevices: {
        const devs = [];
        const model = Bluetooth.devices;
        if (!model) return devs;
        for (let i = 0; i < model.count; i++) {
            const d = model.values[i];
            if (d.name === "" && d.deviceName === "") continue;
            devs.push(d);
        }
        devs.sort((a, b) => {
            if (a.connected !== b.connected) return a.connected ? -1 : 1;
            if (a.paired !== b.paired) return a.paired ? -1 : 1;
            return (a.name || a.deviceName).localeCompare(b.name || b.deviceName);
        });
        return devs;
    }

    onVisibleChanged: {
        if (visible) {
            for (let i = 0; i < allDevices.length; i++) {
                if (allDevices[i].connected) { currentIndex = i; return; }
            }
            currentIndex = 0;
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
            if (allDevices.length > 0)
                currentIndex = Math.min(currentIndex + 1, allDevices.length - 1);
            event.accepted = true;
        } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
            currentIndex = Math.max(currentIndex - 1, 0);
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (currentIndex < allDevices.length) {
                const dev = allDevices[currentIndex];
                if (dev.connected) dev.disconnect();
                else if (dev.paired) dev.connect();
                else dev.pair();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_T) {
            BluetoothState.setPower(!BluetoothState.powered);
            event.accepted = true;
        } else if (event.key === Qt.Key_S) {
            if (BluetoothState.powered) {
                if (BluetoothState.discovering) BluetoothState.stopScan();
                else BluetoothState.startScan();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_D || event.key === Qt.Key_Delete) {
            if (currentIndex < allDevices.length && allDevices[currentIndex].paired && !allDevices[currentIndex].connected) {
                allDevices[currentIndex].forget();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_B) {
            root.dismissed();
            bluemonProc.running = true;
            event.accepted = true;
        }
    }
    Keys.onEscapePressed: dismissed()

    Process {
        id: bluemonProc
        command: ["alacritty", "-e", "bluetoothctl"]
    }

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
        anchors.margins: 14
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Bluetooth"
                font.family: Theme.fontFamily
                font.pixelSize: pfs + 2
                font.bold: true
                color: Theme.textBright
            }
            Text {
                visible: BluetoothState.discovering
                text: "Scanning…"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.accent
            }
            Text {
                text: "CLI (b)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.accent
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { root.dismissed(); bluemonProc.running = true; }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: BluetoothState.powered ? "Bluetooth On" : "Bluetooth Off"
                font.family: Theme.fontFamily
                font.pixelSize: pfs
                color: Theme.textBright
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "(t)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 3
                color: Theme.textMuted
            }
            Rectangle {
                width: 48
                height: 24
                radius: 12
                color: BluetoothState.powered ? Theme.accent : Theme.border
                Behavior on color { ColorAnimation { duration: 150 } }
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                    x: BluetoothState.powered ? parent.width - width - 2 : 2
                    color: Theme.textBright
                    Behavior on x { NumberAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: BluetoothState.setPower(!BluetoothState.powered)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: BluetoothState.powered
            spacing: 12
            Text {
                text: BluetoothState.discovering ? "Scanning for devices…" : "Scan for devices"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.textMuted
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "(s)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 3
                color: Theme.textMuted
            }
            Rectangle {
                width: 48
                height: 24
                radius: 12
                color: BluetoothState.discovering ? Theme.accent : Theme.border
                Behavior on color { ColorAnimation { duration: 150 } }
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                    x: BluetoothState.discovering ? parent.width - width - 2 : 2
                    color: Theme.textBright
                    Behavior on x { NumberAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (BluetoothState.discovering) BluetoothState.stopScan();
                        else BluetoothState.startScan();
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border; visible: BluetoothState.powered }

        Text {
            visible: BluetoothState.powered && allDevices.length === 0
            text: BluetoothState.discovering ? "Looking for devices…" : "No devices found"
            font.family: Theme.fontFamily
            font.pixelSize: pfs - 1
            color: Theme.textMuted
        }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 400)
            contentHeight: devCol.implicitHeight
            clip: true
            visible: BluetoothState.powered && allDevices.length > 0

            onContentHeightChanged: ensureVisible()
            function ensureVisible() {
                if (deviceRepeater.count === 0) return;
                const itemY = currentIndex * 52;
                const itemH = 50;
                if (itemY < contentY) contentY = itemY;
                else if (itemY + itemH > contentY + height)
                    contentY = itemY + itemH - height;
            }

            Connections {
                target: root
                function onCurrentIndexChanged() { parent.ensureVisible(); }
            }

            ColumnLayout {
                id: devCol
                width: parent.width
                spacing: 4

                Repeater {
                    id: deviceRepeater
                    model: root.allDevices
                    delegate: Rectangle {
                        id: devItem
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        implicitHeight: devRow.implicitHeight + 12
                        radius: 3
                        property bool isCurrent: index === root.currentIndex

                        color: isCurrent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                            : devMouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.07)
                            : "transparent"
                        border.width: isCurrent ? 1 : 0
                        border.color: Theme.accent

                        RowLayout {
                            id: devRow
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 10

                            Text {
                                text: BluetoothState.deviceIcon(devItem.modelData.icon)
                                font.family: Theme.fontFamily
                                font.pixelSize: root.pfs + 4
                                color: devItem.modelData.connected ? Theme.accent : Theme.text
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    Layout.fillWidth: true
                                    text: devItem.modelData.name || devItem.modelData.deviceName
                                    font.family: Theme.fontFamily
                                    font.pixelSize: root.pfs
                                    font.bold: devItem.modelData.connected
                                    color: Theme.textBright
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: BluetoothState.stateText(devItem.modelData)
                                    font.family: Theme.fontFamily
                                    font.pixelSize: root.pfs - 3
                                    color: devItem.modelData.connected ? Theme.accent : Theme.textMuted
                                }
                            }

                            Text {
                                visible: devItem.modelData.batteryAvailable && devItem.modelData.connected
                                text: "󰁹 " + Math.round(devItem.modelData.battery) + "%"
                                font.family: Theme.fontFamily
                                font.pixelSize: root.pfs - 2
                                color: devItem.modelData.battery <= 20 ? Theme.danger : Theme.textMuted
                            }
                        }

                        MouseArea {
                            id: devMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onContainsMouseChanged: {
                                if (containsMouse) root.currentIndex = devItem.index;
                            }
                            onClicked: {
                                if (devItem.modelData.connected) devItem.modelData.disconnect();
                                else if (devItem.modelData.paired) devItem.modelData.connect();
                                else devItem.modelData.pair();
                            }
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border; visible: BluetoothState.powered }

        RowLayout {
            Layout.fillWidth: true
            visible: BluetoothState.powered
            spacing: 16
            Text {
                text: "Enter: connect/disconnect  D: forget  T: power  S: scan  Esc: close"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 4
                color: Theme.textMuted
            }
        }
    }
}
