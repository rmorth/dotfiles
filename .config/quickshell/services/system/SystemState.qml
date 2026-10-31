pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string hostname: ""
    property string username: Quickshell.env("USER") || "user"
    property string kernel: ""
    property string uptime: ""
    property string cpu: ""
    property string memUsed: ""
    property string memTotal: ""
    property string memPercent: ""
    property string disk: ""
    property string ipAddr: ""
    property string shell: Quickshell.env("SHELL")?.split("/").pop() || "zsh"
    property string packages: ""
    property string cpuUsage: "0"
    property string cpuTemp: ""
    property real cpuUsageNum: 0
    property real memUsageNum: 0
    property bool panelOpen: false

    function refresh() {
        if (infoProc.running) return;
        infoProc.running = true;
    }

    function lock() { lockProc.running = true; }
    function logout() { logoutProc.running = true; }
    function suspend() { suspendProc.running = true; }
    function hibernate() { hibernateProc.running = true; }
    function reboot() { rebootProc.running = true; }
    function shutdown() { shutdownProc.running = true; }

    Process {
        id: infoProc
        command: ["bash", "-c",
            "host=$(hostnamectl --static 2>/dev/null || hostname); " +
            "kern=$(uname -r); " +
            "up=$(uptime -p 2>/dev/null | sed 's/^up //'); " +
            "cpu=$(lscpu 2>/dev/null | awk -F: '/Model name/{gsub(/^[ \\t]+/,\"\",$2);print $2;exit}'); " +
            "mem_t=$(awk '/MemTotal/{print int($2/1024)}' /proc/meminfo); " +
            "mem_a=$(awk '/MemAvailable/{print int($2/1024)}' /proc/meminfo); " +
            "mem_u=$((mem_t - mem_a)); " +
            "mem_p=$((mem_u * 100 / mem_t)); " +
            "dsk=$(df -h / | awk 'NR==2{print $3\" / \"$2\" (\"$5\")\"}'); " +
            "ip_dev=$(ip -4 route show default 2>/dev/null | awk '{print $5;exit}'); " +
            "ip_addr=N/A; " +
            "[ -n \"$ip_dev\" ] && ip_addr=$(ip -4 addr show dev \"$ip_dev\" scope global 2>/dev/null | awk '/inet/{print $2}' | cut -d/ -f1 | head -1); " +
            "pkgs=$(pacman -Qq 2>/dev/null | wc -l); " +
            "cpu_u=$(awk '/^cpu /{u=$2+$4;t=$2+$3+$4+$5+$6+$7+$8;print int(u*100/t)}' /proc/stat); " +
            "cpu_t=0; " +
            "for h in /sys/class/hwmon/hwmon*/; do " +
            "  [ \"$(cat \"${h}name\" 2>/dev/null)\" = k10temp ] && cpu_t=$(cat \"${h}temp1_input\" 2>/dev/null || echo 0) && break; " +
            "done; " +
            "[ \"$cpu_t\" = 0 ] && cpu_t=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0); " +
            "cpu_t=$((cpu_t / 1000)); " +
            "printf '%s\\n' \"$host\" \"$kern\" \"$up\" \"$cpu\" \"$mem_u\" \"$mem_t\" \"$mem_p\" \"$dsk\" \"$ip_addr\" \"$pkgs\" \"$cpu_u\" \"$cpu_t\""]
        Component.onCompleted: root.refresh()
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length >= 12) {
                    root.hostname = lines[0];
                    root.kernel = lines[1];
                    root.uptime = lines[2];
                    root.cpu = lines[3];
                    root.memUsed = lines[4];
                    root.memTotal = lines[5];
                    root.memPercent = lines[6];
                    root.disk = lines[7];
                    root.ipAddr = lines[8];
                    root.packages = lines[9];
                    root.cpuUsage = lines[10];
                    root.cpuTemp = lines[11];
                    root.cpuUsageNum = parseInt(lines[10]) || 0;
                    root.memUsageNum = parseInt(lines[6]) || 0;
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Process { id: lockProc; command: ["loginctl", "lock-session"] }
    Process { id: logoutProc; command: ["hyprctl", "dispatch", "exit"] }
    Process { id: suspendProc; command: ["systemctl", "suspend"] }
    Process { id: hibernateProc; command: ["systemctl", "hibernate"] }
    Process { id: rebootProc; command: ["systemctl", "reboot"] }
    Process { id: shutdownProc; command: ["systemctl", "poweroff"] }
}
