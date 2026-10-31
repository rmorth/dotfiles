import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config
import qs.services.bluetooth
import qs.modules.bluetooth

Item {
    id: root
    implicitWidth: btIcon.implicitWidth + 8
    implicitHeight: Theme.barHeight
    property bool popupOpen: false

    onPopupOpenChanged: {
        BluetoothState.panelOpen = popupOpen;
    }

    Connections {
        target: root.QsWindow.window
        function onCloseAllPopups() {
            root.popupOpen = false;
        }
    }

    GlobalShortcut {
        name: "bluetooth-toggle"
        description: "Toggle bluetooth popup"
        onPressed: root.popupOpen = !root.popupOpen
    }

    HyprlandFocusGrab {
        windows: [popup]
        active: root.popupOpen && popup.visible
        onCleared: root.popupOpen = false
    }

    Text {
        id: btIcon
        anchors.centerIn: parent
        text: BluetoothState.icon
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize + 2
        color: root.popupOpen ? Theme.accent : Theme.text
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
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
        implicitWidth: btCenter.implicitWidth
        implicitHeight: btCenter.implicitHeight
        color: "transparent"

        onVisibleChanged: {
            if (!visible)
                root.popupOpen = false;
            else
                btCenter.forceActiveFocus();
        }

        BluetoothCenter {
            id: btCenter
            anchors.fill: parent
            onDismissed: root.popupOpen = false
        }
    }
}
