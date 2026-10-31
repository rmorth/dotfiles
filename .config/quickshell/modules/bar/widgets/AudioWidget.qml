import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config
import qs.services.audio
import qs.modules.audio

Item {
    id: root
    implicitWidth: barRow.implicitWidth + 8
    implicitHeight: Theme.barHeight
    property bool popupOpen: false

    onPopupOpenChanged: {
        AudioState.panelOpen = popupOpen;
        if (popupOpen) AudioState.refresh();
    }

    Connections {
        target: root.QsWindow.window
        function onCloseAllPopups() {
            root.popupOpen = false;
        }
    }

    GlobalShortcut {
        name: "audio-toggle"
        description: "Toggle audio popup"
        onPressed: root.popupOpen = !root.popupOpen
    }

    HyprlandFocusGrab {
        windows: [popup]
        active: root.popupOpen && popup.visible
        onCleared: root.popupOpen = false
    }

    Row {
        id: barRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: AudioState.icon
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 2
            color: root.popupOpen ? Theme.accent : Theme.text
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: AudioState.volume + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 3
            color: Theme.textMuted
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onWheel: wheel => AudioState.adjustVolume(wheel.angleDelta.y > 0 ? 5 : -5)
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                AudioState.toggleMute();
                return;
            }
            const shouldOpen = !root.popupOpen;
            root.QsWindow.window?.closeAllPopups();
            root.popupOpen = shouldOpen;
        }
    }

    PopupWindow {
        id: popup
        anchor.window: root.QsWindow.window
        anchor.adjustment: PopupAdjustment.SlideX | PopupAdjustment.SlideY
        anchor.onAnchoring: {
            const window = root.QsWindow.window;
            if (window && window.contentItem) {
                const point = root.mapToItem(window.contentItem, 0, 0);
                const px = point.x + root.width / 2 - popup.width / 2;
                const py = point.y + root.height;
                popup.anchor.rect = Qt.rect(
                    Math.max(0, Math.min(px, window.width - popup.width)),
                    py, 1, 1
                );
            }
        }
        visible: root.popupOpen
        implicitWidth: audioCenter.implicitWidth
        implicitHeight: audioCenter.implicitHeight
        color: "transparent"

        onVisibleChanged: {
            if (!visible)
                root.popupOpen = false;
            else
                audioCenter.forceActiveFocus();
        }

        AudioCenter {
            id: audioCenter
            anchors.fill: parent
            onDismissed: root.popupOpen = false
        }
    }
}
