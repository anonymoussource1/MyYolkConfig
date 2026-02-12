pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
	property string percent: parseInt(UPower.displayDevice.percentage * 100, 10)
	property bool on_battery: UPower.onBattery
	property string time_to_empty: UPower.displayDevice.timeToEmpty
	property string time_to_full: UPower.displayDevice.timeToFull
}
