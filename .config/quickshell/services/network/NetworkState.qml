pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking as Net

Singleton {
    id: root

    readonly property bool available: true
    readonly property bool wifiEnabled: Net.Networking.wifiEnabled
    readonly property bool wifiHardwareEnabled: Net.Networking.wifiHardwareEnabled

    readonly property var wifiDevices: Net.Networking.devices.values.filter(
        device => device.type === Net.DeviceType.Wifi
    )
    readonly property var wiredDevices: Net.Networking.devices.values.filter(
        device => device.type === Net.DeviceType.Wired
    )

    readonly property var wifiNetworks: {
        let networks = [];
        for (const device of wifiDevices)
            for (const network of device.networks.values)
                networks.push(network);
        return networks.filter(n => !!n.name).sort(
            (a, b) => Number(b.connected) - Number(a.connected) || b.signalStrength - a.signalStrength
        );
    }

    readonly property bool connected: wifiNetworks.some(n => n.connected)
            || wiredDevices.some(d => d.connected)

    readonly property string currentSsid: {
        const net = wifiNetworks.find(n => n.connected);
        return net ? net.name : "";
    }

    readonly property real currentSignal: {
        const net = wifiNetworks.find(n => n.connected);
        return net ? net.signalStrength : 0;
    }

    readonly property string icon: {
        if (wiredDevices.some(d => d.connected)) return "󰈀";
        if (!wifiEnabled) return "󰤭";
        const sig = currentSignal;
        if (sig <= 0 && !connected) return "󰤮";
        if (sig < 0.25) return "󰤟";
        if (sig < 0.5) return "󰤢";
        if (sig < 0.75) return "󰤥";
        return "󰤨";
    }

    property bool panelOpen: false
    property string errorMessage: ""
    property bool busy: false
    property var passwordNetwork: null
    property var pendingWifi: null

    property var interfaceSpeeds: ({})
    property real activeRxSpeed: 0
    property real activeTxSpeed: 0
    property var _prevBytes: ({})

    readonly property string activeInterface: {
        const wired = wiredDevices.find(d => d.connected);
        if (wired) return wired.name;
        const wifi = wifiDevices.find(d => d.connected);
        return wifi ? wifi.name : "";
    }

    function formatSpeed(bytesPerSec) {
        if (bytesPerSec < 1024) return bytesPerSec.toFixed(0) + " B/s";
        if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(1) + " K/s";
        return (bytesPerSec / (1024 * 1024)).toFixed(1) + " M/s";
    }

    function formatSpeedCompact(bytesPerSec) {
        if (bytesPerSec < 1024) return "0";
        if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(0) + "K";
        return (bytesPerSec / (1024 * 1024)).toFixed(1) + "M";
    }

    onPanelOpenChanged: {
        for (const device of wifiDevices)
            device.scannerEnabled = panelOpen && wifiEnabled;
        if (!panelOpen) {
            passwordNetwork = null;
            errorMessage = "";
        }
    }
    onWifiEnabledChanged: {
        for (const device of wifiDevices)
            device.scannerEnabled = panelOpen && wifiEnabled;
        if (!wifiEnabled) passwordNetwork = null;
    }

    function setWifi(enabled) {
        Net.Networking.wifiEnabled = enabled;
        if (!enabled) passwordNetwork = null;
    }

    function needsPassword(network) {
        return [
            Net.WifiSecurityType.WpaPsk,
            Net.WifiSecurityType.Wpa2Psk,
            Net.WifiSecurityType.Sae
        ].includes(network.security);
    }

    function securityLabel(network) {
        if (network.security === Net.WifiSecurityType.Open) return "Open";
        if (network.security === Net.WifiSecurityType.Owe) return "Enhanced open";
        if (network.security === Net.WifiSecurityType.Sae) return "WPA3";
        if (needsPassword(network)) return "WPA/WPA2";
        return "Enterprise";
    }

    function connectWifi(network) {
        if (busy || !wifiEnabled) return;
        errorMessage = "";
        if (!network.known && needsPassword(network)) {
            passwordNetwork = network;
            return;
        }
        if (!network.known && ![Net.WifiSecurityType.Open, Net.WifiSecurityType.Owe].includes(network.security)) {
            errorMessage = "Configure this network in nm-connection-editor first.";
            return;
        }
        beginConnect(network);
        network.connect();
    }

    function submitPassword(password) {
        const network = passwordNetwork;
        if (!network || busy) return;
        if (password.length < 8 && network.security !== Net.WifiSecurityType.Sae) {
            errorMessage = "Password must be at least 8 characters.";
            return;
        }
        passwordNetwork = null;
        beginConnect(network);
        network.connectWithPsk(password);
    }

    function beginConnect(network) {
        errorMessage = "";
        busy = true;
        pendingWifi = network;
        connectTimeout.restart();
    }

    function disconnectWifi(network) {
        if (busy) return;
        errorMessage = "";
        network.disconnect();
    }

    function forgetNetwork(network) {
        if (busy) return;
        network.forget();
    }

    function openSettings() {
        editorProc.running = true;
    }

    Connections {
        target: root.pendingWifi
        function onConnectionFailed(reason) {
            const network = root.pendingWifi;
            root.pendingWifi = null;
            root.busy = false;
            connectTimeout.stop();
            if (reason === Net.ConnectionFailReason.NoSecrets && network && root.needsPassword(network)) {
                root.passwordNetwork = network;
                root.errorMessage = "Authentication failed. Enter the password.";
            } else {
                root.errorMessage = "Connection failed.";
            }
        }
        function onConnectedChanged() {
            if (root.pendingWifi?.connected) {
                root.pendingWifi = null;
                root.busy = false;
                connectTimeout.stop();
            }
        }
    }

    Timer {
        id: connectTimeout
        interval: 30000
        onTriggered: {
            root.pendingWifi = null;
            root.busy = false;
            root.errorMessage = "Connection timed out.";
        }
    }

    Timer {
        id: trafficTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: trafficProc.running = true
    }

    Process {
        id: trafficProc
        command: ["cat", "/proc/net/dev"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const now = Date.now();
                const elapsed = (now - (root._lastTrafficTime || now)) / 1000;
                root._lastTrafficTime = now;
                if (elapsed <= 0) {
                    root._parseInitialBytes(lines);
                    return;
                }
                const newSpeeds = {};
                for (let i = 2; i < lines.length; i++) {
                    const parts = lines[i].trim().split(/\s+/);
                    if (parts.length < 10) continue;
                    const iface = parts[0].replace(":", "");
                    if (iface === "lo") continue;
                    const rx = parseInt(parts[1]);
                    const tx = parseInt(parts[9]);
                    const prev = root._prevBytes[iface];
                    if (prev) {
                        newSpeeds[iface] = {
                            rx: Math.max(0, (rx - prev.rx) / elapsed),
                            tx: Math.max(0, (tx - prev.tx) / elapsed)
                        };
                    }
                    root._prevBytes[iface] = { rx, tx };
                }
                root.interfaceSpeeds = newSpeeds;
                const active = root.activeInterface;
                if (active && newSpeeds[active]) {
                    root.activeRxSpeed = newSpeeds[active].rx;
                    root.activeTxSpeed = newSpeeds[active].tx;
                } else {
                    root.activeRxSpeed = 0;
                    root.activeTxSpeed = 0;
                }
            }
        }
    }

    property real _lastTrafficTime: 0

    function _parseInitialBytes(lines) {
        for (let i = 2; i < lines.length; i++) {
            const parts = lines[i].trim().split(/\s+/);
            if (parts.length < 10) continue;
            const iface = parts[0].replace(":", "");
            if (iface === "lo") continue;
            _prevBytes[iface] = { rx: parseInt(parts[1]), tx: parseInt(parts[9]) };
        }
    }

    Process {
        id: editorProc
        command: ["nm-connection-editor"]
    }
}
