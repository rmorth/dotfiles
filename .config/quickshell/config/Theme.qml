pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // Warm-dark palette
    readonly property color background: "#0a0604"
    readonly property color surface: "#1a1210"
    readonly property color border: "#4a3525"
    readonly property color accent: "#ff8c3a"
    readonly property color text: "#d9a066"
    readonly property color textBright: "#e8c098"
    readonly property color textMuted: "#8a6a4a"
    readonly property color danger: "#c0392b"
    readonly property color success: "#27ae60"

    // Workspace colors
    readonly property color wsActive: accent
    readonly property color wsOccupied: text
    readonly property color wsEmpty: "#4a3525"

    // Font
    readonly property string fontFamily: "CommitMono Nerd Font"
    readonly property int fontSize: 14
    readonly property int barHeight: 32
    readonly property int barPadding: 8
    readonly property int widgetSpacing: 12
    readonly property int popupFontSize: 17
}
