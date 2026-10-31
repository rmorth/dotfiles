import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.config
import qs.services.system
import qs.modules.system

Item {
    id: root
    implicitWidth: hostText.implicitWidth + 8
    implicitHeight: Theme.barHeight
    property bool popupOpen: false
    property string hostname: ""

    Process {
        id: hostnameProc
        command: ["hostnamectl", "--static"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.hostname = text.trim()
        }
        onExited: (code, status) => {
            if (code !== 0 || root.hostname === "")
                root.hostname = Quickshell.env("HOSTNAME") || "localhost"
        }
    }

    onPopupOpenChanged: {
        SystemState.panelOpen = popupOpen;
        if (popupOpen) SystemState.refresh();
    }

    Connections {
        target: root.QsWindow.window
        function onCloseAllPopups() {
            root.popupOpen = false;
        }
    }

    GlobalShortcut {
        name: "system-toggle"
        description: "Toggle system popup"
        onPressed: root.popupOpen = !root.popupOpen
    }

    HyprlandFocusGrab {
        windows: [popup]
        active: root.popupOpen && popup.visible
        onCleared: root.popupOpen = false
    }

    Text {
        id: hostText
        anchors.centerIn: parent
        text: root.hostname + " > " + Quickshell.env("USER")
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
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
        anchor.adjustment: PopupAdjustment.None
        anchor.onAnchoring: {
            const window = root.QsWindow.window;
            if (window && window.contentItem) {
                const point = root.mapToItem(window.contentItem, 0, 0);
                popup.anchor.rect = Qt.rect(-point.x + 8, point.y + root.height, 1, 1);
            }
        }
        visible: root.popupOpen
        implicitWidth: systemCenter.implicitWidth
        implicitHeight: systemCenter.implicitHeight
        color: "transparent"

        onVisibleChanged: {
            if (!visible)
                root.popupOpen = false;
            else
                systemCenter.forceActiveFocus();
        }

        SystemCenter {
            id: systemCenter
            anchors.fill: parent
            onDismissed: root.popupOpen = false
        }
    }
}
