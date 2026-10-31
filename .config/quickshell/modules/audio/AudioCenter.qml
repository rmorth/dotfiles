pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config
import qs.services.audio

FocusScope {
    id: root
    implicitWidth: 560
    implicitHeight: content.implicitHeight + 28
    focus: true

    property int currentSection: 0  // 0=output, 1=input, 2=streams
    property int currentDevice: 0
    readonly property int pfs: Theme.popupFontSize

    Keys.onPressed: event => {
        if (event.key === Qt.Key_M) {
            if (event.modifiers & Qt.ShiftModifier)
                AudioState.toggleMicMute();
            else
                AudioState.toggleMute();
            event.accepted = true;
        } else if (event.key === Qt.Key_P) {
            root.dismissed();
            AudioState.openMixer();
            event.accepted = true;
        } else if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
            navigateDevice(1);
            event.accepted = true;
        } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
            navigateDevice(-1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Tab) {
            currentSection = (currentSection + 1) % 3;
            currentDevice = 0;
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            activateCurrentDevice();
            event.accepted = true;
        } else if (event.key === Qt.Key_H || event.key === Qt.Key_Left) {
            adjustCurrentVolume(-5);
            event.accepted = true;
        } else if (event.key === Qt.Key_L || event.key === Qt.Key_Right) {
            adjustCurrentVolume(5);
            event.accepted = true;
        }
    }

    Keys.onEscapePressed: dismissed()
    signal dismissed

    function navigateDevice(delta) {
        const count = currentSection === 0 ? AudioState.sinks.length
            : currentSection === 1 ? AudioState.sources.length
            : AudioState.streams.length;
        if (count === 0) return;
        currentDevice = Math.max(0, Math.min(currentDevice + delta, count - 1));
    }

    function activateCurrentDevice() {
        if (currentSection === 0 && currentDevice < AudioState.sinks.length)
            AudioState.selectSink(AudioState.sinks[currentDevice].name);
        else if (currentSection === 1 && currentDevice < AudioState.sources.length)
            AudioState.selectSource(AudioState.sources[currentDevice].name);
    }

    function adjustCurrentVolume(delta) {
        if (currentSection === 0)
            AudioState.setVolume(AudioState.volume + delta);
        else if (currentSection === 1)
            AudioState.setMicVolume(AudioState.micVolume + delta);
        else if (currentSection === 2 && currentDevice < AudioState.streams.length)
            AudioState.setStreamVolume(AudioState.streams[currentDevice].id, AudioState.streams[currentDevice].volume + delta);
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

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Audio"
                font.family: Theme.fontFamily
                font.pixelSize: pfs + 2
                font.bold: true
                color: Theme.textBright
            }
            Text {
                text: "Mixer (p)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.accent
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { root.dismissed(); AudioState.openMixer(); }
                }
            }
        }

        // Error
        Text {
            Layout.fillWidth: true
            visible: AudioState.errorMessage.length > 0
            text: AudioState.errorMessage
            font.family: Theme.fontFamily
            font.pixelSize: pfs - 2
            color: Theme.danger
            wrapMode: Text.Wrap
        }

        // OUTPUT section
        Text {
            text: "OUTPUT"
            font.family: Theme.fontFamily
            font.pixelSize: pfs - 3
            font.bold: true
            color: Theme.textMuted
        }

        Repeater {
            model: AudioState.sinks
            delegate: Rectangle {
                id: sinkItem
                required property var modelData
                required property int index
                Layout.fillWidth: true
                implicitHeight: sinkRow.implicitHeight + 8
                radius: 3
                property bool isCurrent: root.currentSection === 0 && index === root.currentDevice
                property bool isDefault: modelData.name === AudioState.defaultSink
                color: isCurrent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                    : sinkHover.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.07)
                    : "transparent"
                border.width: isCurrent ? 1 : 0
                border.color: Theme.accent

                RowLayout {
                    id: sinkRow
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 8
                    Text {
                        text: sinkItem.isDefault ? "󰄬" : " "
                        font.family: Theme.fontFamily
                        font.pixelSize: root.pfs
                        color: Theme.accent
                    }
                    Text {
                        Layout.fillWidth: true
                        text: sinkItem.modelData.description
                        font.family: Theme.fontFamily
                        font.pixelSize: root.pfs
                        font.bold: sinkItem.isDefault
                        color: Theme.textBright
                        elide: Text.ElideRight
                    }
                }
                MouseArea {
                    id: sinkHover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioState.selectSink(sinkItem.modelData.name)
                    onContainsMouseChanged: {
                        if (containsMouse) { root.currentSection = 0; root.currentDevice = sinkItem.index; }
                    }
                }
            }
        }

        // Volume slider
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: AudioState.icon
                font.family: Theme.fontFamily
                font.pixelSize: pfs + 2
                color: AudioState.muted ? Theme.textMuted : Theme.text
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioState.toggleMute()
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: Theme.border
                Rectangle {
                    width: parent.width * Math.min(AudioState.volume / 100, 1.5)
                    height: parent.height
                    radius: 3
                    color: AudioState.muted ? Theme.textMuted : Theme.accent
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => AudioState.setVolume(Math.round(mouse.x / width * 100))
                }
            }
            Text {
                text: AudioState.volume + "%"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.textMuted
                Layout.preferredWidth: 40
                horizontalAlignment: Text.AlignRight
            }
            Text {
                text: "(m)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 4
                color: Theme.textMuted
            }
        }

        // Separator
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }

        // INPUT section
        Text {
            text: "INPUT"
            font.family: Theme.fontFamily
            font.pixelSize: pfs - 3
            font.bold: true
            color: Theme.textMuted
        }

        Repeater {
            model: AudioState.sources
            delegate: Rectangle {
                id: srcItem
                required property var modelData
                required property int index
                Layout.fillWidth: true
                implicitHeight: srcRow.implicitHeight + 8
                radius: 3
                property bool isCurrent: root.currentSection === 1 && index === root.currentDevice
                property bool isDefault: modelData.name === AudioState.defaultSource
                color: isCurrent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                    : srcHover.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.07)
                    : "transparent"
                border.width: isCurrent ? 1 : 0
                border.color: Theme.accent

                RowLayout {
                    id: srcRow
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 8
                    Text {
                        text: srcItem.isDefault ? "󰄬" : " "
                        font.family: Theme.fontFamily
                        font.pixelSize: root.pfs
                        color: Theme.accent
                    }
                    Text {
                        Layout.fillWidth: true
                        text: srcItem.modelData.description
                        font.family: Theme.fontFamily
                        font.pixelSize: root.pfs
                        font.bold: srcItem.isDefault
                        color: Theme.textBright
                        elide: Text.ElideRight
                    }
                }
                MouseArea {
                    id: srcHover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioState.selectSource(srcItem.modelData.name)
                    onContainsMouseChanged: {
                        if (containsMouse) { root.currentSection = 1; root.currentDevice = srcItem.index; }
                    }
                }
            }
        }

        // Mic volume slider
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: AudioState.micIcon
                font.family: Theme.fontFamily
                font.pixelSize: pfs + 2
                color: AudioState.micMuted ? Theme.textMuted : Theme.text
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioState.toggleMicMute()
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: Theme.border
                Rectangle {
                    width: parent.width * Math.min(AudioState.micVolume / 100, 1)
                    height: parent.height
                    radius: 3
                    color: AudioState.micMuted ? Theme.textMuted : Theme.accent
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => AudioState.setMicVolume(Math.round(mouse.x / width * 100))
                }
            }
            Text {
                text: AudioState.micVolume + "%"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 2
                color: Theme.textMuted
                Layout.preferredWidth: 40
                horizontalAlignment: Text.AlignRight
            }
            Text {
                text: "(M)"
                font.family: Theme.fontFamily
                font.pixelSize: pfs - 4
                color: Theme.textMuted
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
            visible: AudioState.streams.length > 0
        }

        // APPLICATIONS section
        Text {
            visible: AudioState.streams.length > 0
            text: "APPLICATIONS"
            font.family: Theme.fontFamily
            font.pixelSize: pfs - 3
            font.bold: true
            color: Theme.textMuted
        }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 200)
            contentHeight: streamCol.implicitHeight
            clip: true
            visible: AudioState.streams.length > 0

            ColumnLayout {
                id: streamCol
                width: parent.width
                spacing: 6

                Repeater {
                    model: AudioState.streams
                    delegate: RowLayout {
                        id: streamItem
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        spacing: 8
                        property bool isCurrent: root.currentSection === 2 && index === root.currentDevice

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: streamItem.isCurrent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1) : "transparent"
                            border.width: streamItem.isCurrent ? 1 : 0
                            border.color: Theme.accent

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 8
                                Text {
                                    text: streamItem.modelData.name
                                    font.family: Theme.fontFamily
                                    font.pixelSize: root.pfs - 1
                                    color: Theme.textBright
                                    Layout.preferredWidth: 120
                                    elide: Text.ElideRight
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 4
                                    radius: 2
                                    color: Theme.border
                                    Rectangle {
                                        width: parent.width * Math.min(streamItem.modelData.volume / 100, 1.5)
                                        height: parent.height
                                        radius: 2
                                        color: streamItem.modelData.muted ? Theme.textMuted : Theme.accent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: mouse => AudioState.setStreamVolume(streamItem.modelData.id, Math.round(mouse.x / width * 100))
                                    }
                                }
                                Text {
                                    text: streamItem.modelData.volume + "%"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: root.pfs - 3
                                    color: Theme.textMuted
                                    Layout.preferredWidth: 36
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                            onContainsMouseChanged: {
                                if (containsMouse) { root.currentSection = 2; root.currentDevice = streamItem.index; }
                            }
                        }
                    }
                }
            }
        }
    }
}
