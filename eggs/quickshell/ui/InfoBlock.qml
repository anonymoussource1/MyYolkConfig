import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: root

	property string icon
	property string info
	
	implicitWidth: content.width + Appearance.block_padding
	implicitHeight: info_text.height + Appearance.block_padding

	Behavior on implicitWidth {
		NumberAnimation {
			duration: 200
			//easing.type: Easing.InOutQuint
		}
	}

	color: Appearance.secondary_color
	radius: 10

	Behavior on info {
		ParallelAnimation {
			NumberAnimation {
				target: info_text
				property: "opacity"
				running: false
				from: 0
				to: 1
				duration: 300
			}
			NumberAnimation {
				target: icon_text
				property: "opacity"
				running: false
				from: 0
				to: 1
				duration: 300
			}
		}
	}

	RowLayout {
		id: content
		anchors.centerIn: parent

		Text {
			id: icon_text
			text: icon
			color: Appearance.text_color
			font { pointSize: 14; family: "Material Symbols Rounded" }
		}

		Text {
			id: info_text
			text: info
			clip: true
			color: Appearance.text_color
			font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }
		}
	}
}
