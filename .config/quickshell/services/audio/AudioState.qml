pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int volume: 0
    property bool muted: false
    property var sinks: []
    property string defaultSink: ""

    property int micVolume: 0
    property bool micMuted: false
    property var sources: []
    property string defaultSource: ""

    property var streams: []

    property string errorMessage: ""
    property bool busy: false
    property bool panelOpen: false

    readonly property string icon: {
        if (muted || volume === 0) return "󰖁";
        if (volume < 33) return "󰕿";
        if (volume < 66) return "󰖀";
        return "󰕾";
    }

    readonly property string micIcon: micMuted ? "󰍭" : "󰍬"

    function refresh() {
        if (statusProc.running) return;
        statusProc.running = true;
    }

    function setVolume(value) {
        value = Math.round(Math.max(0, Math.min(150, value)));
        volume = value;
        runCmd(["pactl", "set-sink-volume", defaultSink, value + "%"]);
    }

    function adjustVolume(delta) {
        setVolume(volume + delta);
    }

    function toggleMute() {
        runCmd(["pactl", "set-sink-mute", defaultSink, "toggle"]);
    }

    function setMicVolume(value) {
        value = Math.round(Math.max(0, Math.min(100, value)));
        micVolume = value;
        runCmd(["pactl", "set-source-volume", defaultSource, value + "%"]);
    }

    function toggleMicMute() {
        runCmd(["pactl", "set-source-mute", defaultSource, "toggle"]);
    }

    function selectSink(name) {
        if (busy) return;
        busy = true;
        errorMessage = "";
        selectSinkProc.command = ["bash", "-c",
            "pactl set-default-sink \"$1\"; " +
            "for id in $(pactl --format=json list sink-inputs | jq -r '.[].index'); do " +
            "  pactl move-sink-input \"$id\" \"$1\" 2>/dev/null || true; " +
            "done", "--", name];
        selectSinkProc.running = true;
    }

    function selectSource(name) {
        if (busy) return;
        busy = true;
        errorMessage = "";
        selectSourceProc.command = ["bash", "-c",
            "pactl set-default-source \"$1\"; " +
            "for id in $(pactl --format=json list source-outputs | jq -r '.[].index'); do " +
            "  pactl move-source-output \"$id\" \"$1\" 2>/dev/null || true; " +
            "done", "--", name];
        selectSourceProc.running = true;
    }

    function setStreamVolume(id, value) {
        value = Math.round(Math.max(0, Math.min(150, value)));
        for (let i = 0; i < streams.length; i++) {
            if (streams[i].id === id) {
                let s = Object.assign({}, streams[i]);
                s.volume = value;
                let copy = streams.slice();
                copy[i] = s;
                streams = copy;
                break;
            }
        }
        runCmd(["pactl", "set-sink-input-volume", String(id), value + "%"]);
    }

    function toggleStreamMute(id) {
        runCmd(["pactl", "set-sink-input-mute", String(id), "toggle"]);
    }

    function openMixer() {
        mixerProc.running = true;
    }

    property var _cmdQueue: []
    function runCmd(cmd) {
        _cmdQueue.push(cmd);
        _runNext();
    }
    function _runNext() {
        if (cmdProc.running || _cmdQueue.length === 0) return;
        cmdProc.command = _cmdQueue.shift();
        cmdProc.running = true;
    }

    Process {
        id: cmdProc
        onExited: (exitCode, exitStatus) => {
            Qt.callLater(() => { root._runNext(); root.refresh(); });
        }
    }

    Process {
        id: selectSinkProc
        onExited: (exitCode, exitStatus) => {
            root.busy = false;
            if (exitCode !== 0)
                root.errorMessage = "Failed to switch output.";
            Qt.callLater(root.refresh);
        }
    }

    Process {
        id: selectSourceProc
        onExited: (exitCode, exitStatus) => {
            root.busy = false;
            if (exitCode !== 0)
                root.errorMessage = "Failed to switch input.";
            Qt.callLater(root.refresh);
        }
    }

    Process {
        id: statusProc
        command: ["bash", "-c",
            "ds=$(pactl get-default-sink); " +
            "dsrc=$(pactl get-default-source 2>/dev/null || true); " +
            "sinks=$(pactl --format=json list sinks); " +
            "sources=$(pactl --format=json list sources); " +
            "inputs=$(pactl --format=json list sink-inputs); " +
            "jq -n --arg ds \"$ds\" --arg dsrc \"$dsrc\" " +
            "  --argjson sinks \"$sinks\" --argjson sources \"$sources\" " +
            "  --argjson inputs \"$inputs\" " +
            "  '{defaultSink:$ds, defaultSource:$dsrc, sinks:$sinks, sources:$sources, inputs:$inputs}'"]
        Component.onCompleted: root.refresh()
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    root.defaultSink = data.defaultSink;
                    root.defaultSource = data.defaultSource;

                    root.sinks = data.sinks.map(s => ({
                        name: s.name,
                        description: s.description || s.name
                    }));

                    const monitorNames = data.sinks.map(s => s.monitor_source);
                    root.sources = data.sources.filter(s =>
                        !monitorNames.includes(s.name) &&
                        !s.name.endsWith(".monitor") &&
                        s.properties?.["device.class"] !== "monitor"
                    ).map(s => ({
                        name: s.name,
                        description: s.description || s.name
                    }));

                    const activeSink = data.sinks.find(s => s.name === data.defaultSink);
                    if (activeSink) {
                        root.muted = !!activeSink.mute;
                        const ch = Object.values(activeSink.volume || {});
                        root.volume = ch.length ? Math.round(ch.reduce((sum, c) => sum + parseInt(c.value_percent), 0) / ch.length) : 0;
                    }

                    const activeSrc = data.sources.find(s => s.name === data.defaultSource);
                    if (activeSrc) {
                        root.micMuted = !!activeSrc.mute;
                        const ch = Object.values(activeSrc.volume || {});
                        root.micVolume = ch.length ? Math.round(ch.reduce((sum, c) => sum + parseInt(c.value_percent), 0) / ch.length) : 0;
                    }

                    root.streams = data.inputs.map(inp => {
                        const props = inp.properties || {};
                        const ch = Object.values(inp.volume || {});
                        return {
                            id: inp.index,
                            name: props["application.name"] || props["application.process.binary"] || "Unknown",
                            iconName: props["application.icon_name"] || "",
                            volume: ch.length ? Math.round(ch.reduce((sum, c) => sum + parseInt(c.value_percent), 0) / ch.length) : 0,
                            muted: !!inp.mute
                        };
                    });

                    if (root.errorMessage === "Audio unavailable.")
                        root.errorMessage = "";
                } catch (e) {
                    root.errorMessage = "Audio unavailable.";
                }
            }
        }
    }

    Process {
        id: mixerProc
        command: ["pavucontrol"]
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
