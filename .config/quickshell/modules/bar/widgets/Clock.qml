import QtQuick
import Quickshell
import qs.config

Text {
    id: clock

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    text: Qt.formatDateTime(sysClock.date, "yyyy-MM-dd HH:mm:ss")
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: Theme.textBright
}
