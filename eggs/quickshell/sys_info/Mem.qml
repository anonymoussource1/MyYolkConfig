pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	property string percent

	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			mem.reload();
		}
	}

	FileView {
		id: mem
		path: "/proc/meminfo"
		onLoaded: {
			const total = text().match(/MemTotal:\s+(\d+)/);
			const free = text().match(/MemFree:\s+(\d+)/);
			if (total && free) {
				const totalInt = parseInt(total[1], 10);
				const freeInt = parseInt(free[1], 10);

				percent = ((1 - (freeInt / totalInt)) * 100).toFixed(2);
			}
		}
	}
}
