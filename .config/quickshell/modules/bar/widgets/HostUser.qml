import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Text {
    id: root
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

    text: hostname + " > " + Quickshell.env("USER") + " |"
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: Theme.text
}
