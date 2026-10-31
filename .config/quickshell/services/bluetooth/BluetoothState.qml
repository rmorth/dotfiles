pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter ? adapter.enabled : false
    readonly property bool discovering: adapter ? adapter.discovering : false
    property bool panelOpen: false

    readonly property string icon: {
        if (!powered) return "󰂲";
        const devs = Bluetooth.devices;
        for (let i = 0; i < devs.count; i++) {
            if (devs.values[i].connected) return "󰂱";
        }
        return "󰂯";
    }

    function deviceIcon(iconType) {
        switch (iconType) {
            case "audio-headset":
            case "audio-headphones": return "󰋋";
            case "audio-card": return "󰓃";
            case "input-keyboard": return "󰌌";
            case "input-mouse": return "󰍽";
            case "input-gaming": return "󰊗";
            case "input-tablet": return "󰓶";
            case "phone": return "󰏲";
            case "computer": return "󰌢";
            case "network-wireless": return "󰖩";
            default: return "󰂯";
        }
    }

    function stateText(device) {
        switch (device.state) {
            case BluetoothDeviceState.Connecting: return "Connecting…";
            case BluetoothDeviceState.Disconnecting: return "Disconnecting…";
            case BluetoothDeviceState.Connected:
                if (device.batteryAvailable) return "Connected · " + Math.round(device.battery) + "%";
                return "Connected";
            default:
                if (device.paired) return "Paired";
                return "Available";
        }
    }

    function setPower(on) {
        if (adapter) adapter.enabled = on;
    }

    function startScan() {
        if (adapter && powered) adapter.discovering = true;
    }

    function stopScan() {
        if (adapter) adapter.discovering = false;
    }

    onPanelOpenChanged: {
        if (panelOpen && powered) startScan();
        else if (!panelOpen) stopScan();
    }
}
