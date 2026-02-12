import Quickshell
import QtQuick

Rectangle {
	color: Appearance.secondary_color
	radius: 10

	implicitWidth: child.width + Appearance.block_padding
	implicitHeight: child.height + Appearance.block_padding

	anchors.margins: Appearance.margin

	Text {
		id: child
		text: Qt.formatDateTime(clock.date, "d // hh:mm")
		font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }
		color: Appearance.text_color
		anchors.centerIn: parent
	}

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}
}
