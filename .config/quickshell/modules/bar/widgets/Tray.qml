import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.config

Row {
    id: root
    spacing: 4
    Layout.alignment: Qt.AlignVCenter

    Repeater {
        model: SystemTray.items

        delegate: MouseArea {
            id: trayItem
            required property var modelData
            width: 24
            height: 24
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            IconImage {
                id: icon
                anchors.centerIn: parent
                width: 18
                height: 18
                source: trayItem.modelData.icon
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: icon.status !== Image.Ready
                text: "●"
                font.pixelSize: 10
                color: Theme.textMuted
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: trayItem.modelData.menu
                anchor.window: trayItem.QsWindow.window
                anchor.adjustment: PopupAdjustment.Flip
                anchor.onAnchoring: {
                    const window = trayItem.QsWindow.window;
                    if (window && window.contentItem)
                        menuAnchor.anchor.rect = window.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, 1);
                }
            }

            onClicked: event => {
                if (event.button === Qt.RightButton || modelData.onlyMenu) {
                    if (modelData.hasMenu)
                        menuAnchor.open();
                } else {
                    modelData.activate();
                }
            }
        }
    }
}
