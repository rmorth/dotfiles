import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.config
import qs.modules.bar.widgets

PanelWindow {
    id: bar
    signal closeAllPopups()
    WlrLayershell.namespace: "quickshell-bar"

    required property var assignedScreen
    screen: assignedScreen
    visible: !barHidden

    property bool barHidden: false

    GlobalShortcut {
        name: "bar-toggle"
        description: "Toggle bar visibility"
        onPressed: bar.barHidden = !bar.barHidden
    }

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    color: Theme.background

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.barPadding
        anchors.rightMargin: Theme.barPadding
        spacing: 0

        // Left section
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            SystemWidget {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Center — workspaces
        WorkspaceBar {}

        // Right section
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.widgetSpacing

                Tray {}
                AudioWidget {}
                BluetoothWidget {}
                NetworkWidget {}
                StatsWidget {}
                Clock {}
            }
        }
    }
}
