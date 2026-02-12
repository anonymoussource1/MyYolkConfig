import Quickshell
import Quickshell.Wayland
import Quickshell.I3
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../sys_info"
import "../ui"

PanelWindow {
	id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
	implicitHeight: bar.height + 30
	exclusiveZone: bar.height + 8
	color: "transparent"

	Rectangle {
		id: bar
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		implicitHeight: childrenRect.height + 2 * Appearance.margin

		//bottomLeftRadius: 10
		//bottomRightRadius: 10
		radius: 10
		anchors.margins: Appearance.margin

		color: Appearance.primary_color

		Rectangle {
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
			anchors.margins: Appearance.margin

			color: Appearance.secondary_color
			radius: 10

			implicitWidth: child.width + Appearance.block_padding
			implicitHeight: child.height + Appearance.block_padding

			RowLayout {
				id: child
				spacing: Appearance.margin
				anchors.centerIn: parent

				Repeater {
					model: 9

					Rectangle {
						implicitWidth: 15
						implicitHeight: 15
						color: "transparent"

						Text {
							id: workspace

							property var ws: I3.workspaces.values.find(w => w.number === index + 1)
							property bool isActive: I3.focusedWorkspace?.number === (index + 1)

							state: isActive ? "focused" : (ws ? "unfocused" : "empty")

							states: [
								State {
									name: "unfocused"
									PropertyChanges { target: workspace; text: "" }
								},
								State {
									name: "focused"
									PropertyChanges { target: workspace; text: "" }
								},
								State {
									name: "empty"
									PropertyChanges { target: workspace; text: "" }
								}
							]

							transitions: [
								Transition {
									from: "*"
									to: "focused"
									SequentialAnimation {
										NumberAnimation {
											target: workspace
											property: "font.pointSize"
											from: 11
											to: 15
											duration: 100
										}

										NumberAnimation {
											target: workspace
											property: "font.pointSize"
											from: 15
											to: 11
											duration: 100
										}
									}
								},
								Transition {
									from: "*"
									to: "unfocused"
									SequentialAnimation {
										NumberAnimation {
											target: workspace
											property: "font.pointSize"
											from: 11
											to: 15
											duration: 100
										}

										NumberAnimation {
											target: workspace
											property: "font.pointSize"
											from: 15
											to: 11
											duration: 100
										}
									}
								}
							]

							anchors.centerIn: parent

							color: Appearance.text_color
							font { pointSize: 11; bold: true }

							MouseArea {
								anchors.fill: parent
								onClicked: I3.dispatch(`workspace number ${index + 1}`)
							}
						}
					}
				}
			}
		}

		TimeBlock {
			id: time
			anchors.centerIn: parent
		}

		RowLayout {
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			anchors.margins: Appearance.margin
			spacing: Appearance.margin

			InfoBlock { 
				icon: Volume.is_muted ? "volume_off" : (
					  Volume.percent < 35 ? "volume_mute" : (
					  Volume.percent < 65 ? "volume_down" : "volume_up"))
				info: Volume.percent + "%"
			}

			InfoBlock { 
				property var percent: Battery.percent
				icon: Battery.on_battery ? (
						  Battery.percent < 13 ? "battery_0_bar" : (
						  Battery.percent < 25 ? "battery_1_bar" : (
						  Battery.percent < 38 ? "battery_2_bar" : (
						  Battery.percent < 50 ? "battery_3_bar" : (
						  Battery.percent < 63 ? "battery_4_bar" : (
						  Battery.percent < 75 ? "battery_5_bar" : (
						  Battery.percent < 88 ? "battery_6_bar" : "battery_full")))))))
					: (
						  Battery.percent < 10 ? "battery_charging_full" : (
						  Battery.percent < 20 ? "battery_charging_20" : (
						  Battery.percent < 30 ? "battery_charging_30" : (
						  Battery.percent < 80 ? "battery_charging_80" : (
						  Battery.percent < 90 ? "battery_charging_90" : "battery_full")))))
				info: percent + "%"

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					onEntered: get_time.restart()
					onExited: function() {
						get_time.stop()
						parent.info = Battery.percent + "%"
					}
				}

				Timer {
					id: get_time
					interval: 500
					property var hours: ((Battery.on_battery ? Battery.time_to_empty : Battery.time_to_full) / 60 / 60).toFixed(0);
					property var minutes: ((Battery.on_battery ? Battery.time_to_empty : Battery.time_to_full) / 60).toFixed(0);
					onTriggered: parent.info = hours + "h " + Math.abs(hours * 60 - minutes) + "m"
				}

				onPercentChanged: info = Battery.percent + "%"
			}

			InfoBlock {
				property var percent: Network.percent
				icon: Network.percent < 17 ? "signal_wifi_0_bar" : (
					  Network.percent < 34 ? "network_wifi_1_bar" : (
					  Network.percent < 51 ? "network_wifi_2_bar" : (
					  Network.percent < 68 ? "network_wifi_3_bar" : (
					  Network.percent < 85 ? "network_wifi" : "signal_wifi_4_bar"))))
				info: Network.percent + "%"

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					onEntered: get_net_info.restart()
					onExited: function() {
						parent.info = Network.percent + "%"
						get_net_info.stop()
					}
				}

				Timer {
					id: get_net_info
					interval: 500
					onTriggered: parent.info = Network.ip + " on " + Network.name
				}

				onPercentChanged: info = Network.percent + "%"
			}

			InfoBlock { icon: "memory"; info: Cpu.percent + "%" }

			InfoBlock { icon: "memory_alt"; info: Mem.percent + "%" }
		}
	}

	MultiEffect {
		anchors.fill: bar
		source: bar
		shadowEnabled: true
		shadowVerticalOffset: 2
		blurMultiplier: 0.1
		shadowOpacity: 1
	}
}
