import Quickshell
import Quickshell.Wayland
import QtQuick
import "../ui"

PanelWindow {
	aboveWindows: false
	exclusionMode: ExclusionMode.Ignore

	anchors.left: true
	anchors.right: true
	anchors.top: true
	anchors.bottom: true

	Image {
		anchors.fill: parent
		source: "/home/danielkurz/Backgrounds/bg4.jpg"

		Rectangle {
			implicitWidth: 400
			implicitHeight: 150
			anchors.centerIn: parent
			color: "transparent"

			Text {
				text: Qt.formatDateTime(clock.date, "hh")

				anchors.left: parent.left
				anchors.top: parent.top

				font { pointSize: 60; family: "BigBlueTermPlusNerdFont"; }
				style: Text.Outline
				styleColor: Appearance.primary_color 
				color: Appearance.secondary_color
			}

			Text {
				text: Qt.formatDateTime(clock.date, "mm")
				anchors.centerIn: parent
				font { pointSize: 60; family: "BigBlueTermPlusNerdFont"; }
				style: Text.Outline
				styleColor: Appearance.primary_color 
				color: Appearance.secondary_color
			}

			Text {
				text: Qt.formatDateTime(clock.date, "ss")
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				font { pointSize: 60; family: "BigBlueTermPlusNerdFont"; }
				style: Text.Outline
				styleColor: Appearance.primary_color 
				color: Appearance.secondary_color
			}
		}

		SystemClock {
			id: clock
			precision: SystemClock.Seconds
		}
	}
}
