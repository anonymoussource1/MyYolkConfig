import Quickshell
import QtQuick

Item {
	property alias inner: loader.sourceComponent

	implicitWidth: childrenRect.width + 10
	implicitHeight: childrenRect.height + 10

	Rectangle {
		color: "#A68A64"
		radius: 10

		Loader {
			id: loader
		}
	}
}
