pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config
import qs.services.network

FocusScope {
    id: root
    implicitWidth: 560
    implicitHeight: content.implicitHeight + 28
    focus: true

    property int currentIndex: -1
    readonly property int networkCount: NetworkState.wifiEnabled ? NetworkState.wifiNetworks.length : 0

    onVisibleChanged: {
        if (visible) {
            const nets = NetworkState.wifiNetworks;
            const connIdx = nets.findIndex(n => n.connected);
            currentIndex = nets.length > 0 ? (connIdx >= 0 ? connIdx : 0) : -1;
        }
    }

    onCurrentIndexChanged: {
        if (currentIndex < 0) return;
        const item = networkListRepeater.itemAt(currentIndex);
        if (!item || !networkFlickable) return;
        const itemTop = item.y;
        const itemBottom = itemTop + item.height;
        if (itemTop < networkFlickable.contentY)
            networkFlickable.contentY = itemTop;
        else if (itemBottom > networkFlickable.contentY + networkFlickable.height)
            networkFlickable.contentY = itemBottom - networkFlickable.height;
    }

    Keys.onPressed: event => {
        if (NetworkState.passwordNetwork) return;

        if (event.key === Qt.Key_T) {
            NetworkState.setWifi(!NetworkState.wifiEnabled);
            event.accepted = true;
            return;
        }
        if (event.key === Qt.Key_A) {
            root.dismissed();
            NetworkState.openSettings();
            event.accepted = true;
            return;
        }

        const count = root.networkCount;
        if (count === 0) return;

        if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
            root.currentIndex = Math.min(root.currentIndex + 1, count - 1);
            event.accepted = true;
        } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
            root.currentIndex = Math.max(root.currentIndex - 1, 0);
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (root.currentIndex >= 0 && root.currentIndex < count) {
                const net = NetworkState.wifiNetworks[root.currentIndex];
                if (!NetworkState.busy && !net.stateChanging) {
                    if (net.connected)
                        NetworkState.disconnectWifi(net);
                    else
                        NetworkState.connectWifi(net);
                }
            }
            event.accepted = true;
        }
    }

    Keys.onEscapePressed: {
        if (NetworkState.passwordNetwork)
            NetworkState.passwordNetwork = null;
        else
            dismissed();
    }
    signal dismissed

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
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Network"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.popupFontSize + 2
                font.bold: true
                color: Theme.textBright
            }
            Text {
                text: "Advanced (a)"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.popupFontSize - 2
                color: Theme.accent
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.dismissed();
                        NetworkState.openSettings();
                    }
                }
            }
        }

        // Error / busy message
        Text {
            Layout.fillWidth: true
            visible: text.length > 0
            text: NetworkState.errorMessage || (NetworkState.busy ? "Connecting…" : "")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.popupFontSize - 2
            color: NetworkState.errorMessage ? Theme.danger : Theme.accent
            wrapMode: Text.Wrap
        }

        // Password prompt
        Rectangle {
            Layout.fillWidth: true
            visible: NetworkState.passwordNetwork !== null
            implicitHeight: passwordCol.implicitHeight + 16
            color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1)
            border.color: Theme.accent
            border.width: 1
            radius: 4

            ColumnLayout {
                id: passwordCol
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                Text {
                    text: NetworkState.passwordNetwork?.name || "Wi-Fi password"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.popupFontSize
                    font.bold: true
                    color: Theme.textBright
                }
                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Password"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.popupFontSize
                    color: Theme.textBright
                    background: Rectangle {
                        color: Theme.background
                        border.color: Theme.border
                        radius: 2
                    }
                    onAccepted: NetworkState.submitPassword(text)
                }
                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 8
                    Text {
                        text: "Cancel"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.popupFontSize - 2
                        color: Theme.textMuted
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: NetworkState.passwordNetwork = null
                        }
                    }
                    Text {
                        text: "Connect"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.popupFontSize - 2
                        color: passwordField.text.length > 0 ? Theme.accent : Theme.textMuted
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: passwordField.text.length > 0 && !NetworkState.busy
                            onClicked: NetworkState.submitPassword(passwordField.text)
                        }
                    }
                }
            }

            Connections {
                target: NetworkState
                function onPasswordNetworkChanged() {
                    passwordField.text = "";
                    if (NetworkState.passwordNetwork)
                        passwordField.forceActiveFocus();
                }
            }
        }

        // WiFi toggle
        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Wi-Fi (t)"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.popupFontSize
                color: Theme.text
            }
            Switch {
                checked: NetworkState.wifiEnabled
                enabled: NetworkState.wifiHardwareEnabled && NetworkState.wifiDevices.length > 0
                onToggled: NetworkState.setWifi(checked)
                indicator: Rectangle {
                    implicitWidth: 48
                    implicitHeight: 24
                    radius: 12
                    color: parent.checked ? Theme.accent : Theme.border
                    Rectangle {
                        x: parent.parent.checked ? parent.width - width - 3 : 3
                        y: 3
                        width: 18
                        height: 18
                        radius: 9
                        color: Theme.textBright
                        Behavior on x { NumberAnimation { duration: 150 } }
                    }
                }
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        // Network list
        Text {
            visible: !NetworkState.wifiEnabled || NetworkState.wifiNetworks.length === 0
            text: !NetworkState.wifiEnabled ? "Wi-Fi is off"
                : NetworkState.wifiDevices.length === 0 ? "No Wi-Fi adapter"
                : "Scanning…"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.popupFontSize - 1
            color: Theme.textMuted
        }

        Flickable {
            id: networkFlickable
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 360)
            contentHeight: networkList.implicitHeight
            clip: true
            visible: NetworkState.wifiEnabled && NetworkState.wifiNetworks.length > 0

            ColumnLayout {
                id: networkList
                width: parent.width
                spacing: 2

                Repeater {
                    id: networkListRepeater
                    model: NetworkState.wifiEnabled ? NetworkState.wifiNetworks : []

                    delegate: Rectangle {
                        id: netItem
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        implicitHeight: netRow.implicitHeight + 12
                        radius: 3
                        property bool isCurrent: index === root.currentIndex
                        color: isCurrent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                            : netHover.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.07)
                            : "transparent"
                        border.width: isCurrent ? 1 : 0
                        border.color: Theme.accent

                        RowLayout {
                            id: netRow
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 8

                            Text {
                                text: netItem.modelData.signalStrength >= 0.75 ? "󰤨"
                                    : netItem.modelData.signalStrength >= 0.5 ? "󰤥"
                                    : netItem.modelData.signalStrength >= 0.25 ? "󰤢"
                                    : "󰤟"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.popupFontSize + 2
                                color: netItem.modelData.connected ? Theme.accent : Theme.textMuted
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    Layout.fillWidth: true
                                    text: netItem.modelData.name
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.popupFontSize
                                    font.bold: netItem.modelData.connected
                                    color: Theme.textBright
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: {
                                        let t = Math.round(netItem.modelData.signalStrength * 100) + "%"
                                            + " · " + NetworkState.securityLabel(netItem.modelData)
                                            + (netItem.modelData.known ? " · Saved" : "");
                                        if (netItem.modelData.connected) {
                                            const iface = NetworkState.wifiDevices.find(d => d.connected)?.name;
                                            const s = iface ? NetworkState.interfaceSpeeds[iface] : null;
                                            if (s) t += "  ↓ " + NetworkState.formatSpeed(s.rx) + " ↑ " + NetworkState.formatSpeed(s.tx);
                                        }
                                        return t;
                                    }
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.popupFontSize - 3
                                    color: Theme.textMuted
                                }
                            }
                            Text {
                                text: netItem.modelData.stateChanging ? "…"
                                    : netItem.modelData.connected ? "Disconnect"
                                    : "Connect"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.popupFontSize - 2
                                color: netItem.modelData.connected ? Theme.textMuted : Theme.accent
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    enabled: !NetworkState.busy && !netItem.modelData.stateChanging
                                    onClicked: {
                                        if (netItem.modelData.connected)
                                            NetworkState.disconnectWifi(netItem.modelData);
                                        else
                                            NetworkState.connectWifi(netItem.modelData);
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: netHover
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                            onContainsMouseChanged: {
                                if (containsMouse)
                                    root.currentIndex = netItem.index;
                            }
                        }
                    }
                }
            }
        }

        // Wired status
        Repeater {
            model: NetworkState.wiredDevices

            delegate: ColumnLayout {
                required property var modelData
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "󰈀"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.popupFontSize + 2
                        color: modelData.connected ? Theme.accent : Theme.textMuted
                    }
                    Text {
                        Layout.fillWidth: true
                        text: modelData.name + (modelData.connected ? " · Connected" : " · Disconnected")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.popupFontSize - 1
                        color: Theme.text
                    }
                }
                Text {
                    visible: modelData.connected && NetworkState.interfaceSpeeds[modelData.name] !== undefined
                    text: {
                        const s = NetworkState.interfaceSpeeds[modelData.name];
                        if (!s) return "";
                        return "    ↓ " + NetworkState.formatSpeed(s.rx) + "  ↑ " + NetworkState.formatSpeed(s.tx);
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.popupFontSize - 3
                    color: Theme.textMuted
                }
            }
        }
    }
}
