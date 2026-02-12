pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	property string percent
	property real prevTotal
	property real prevIdle

	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			cpu.reload();
		}
	}

	FileView {
		id: cpu
		path: "/proc/stat"
		onLoaded: {
			const content = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
			if (content) {
				const times = content.slice(1, 8).map(n => parseInt(n, 10));

				const total = times.reduce((a, b) => a + b, 0);
				const idle = times[3] + times[4];

				const totalSince = total - prevTotal;
				const idleSince = idle - prevIdle;

				percent = (((totalSince - idleSince) / totalSince) * 100).toFixed(2);

				prevTotal = total;
				prevIdle = idle;
			}
		}
	}
}
