pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	property string percent
	property string ip
	property string name

	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			signalAndName.running = true;
			getIp.running = true;
		}
	}

	Process {
		id: signalAndName
		running: true
		command: [ "nmcli", "-g", "IN-USE,SSID,SIGNAL", "d", "wifi" ]	
		stdout: SplitParser {
			onRead: function(data) {
				if (data.match(/^\*/)) {
					name = data.split(":")[1]
					percent = data.split(":")[2]
				}
			}
		}
	}

	Process {
		id: getIp
		running: true
		command: [ "nmcli", "-g", "IP4.ADDRESS", "d", "show" ]
		stdout: StdioCollector {
			onStreamFinished: {
				const address = text.split("\n")[0];

				ip = address.split("/")[0];
			}
		}
	}
}
