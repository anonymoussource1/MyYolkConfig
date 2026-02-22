import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../ui"

Item {
	LazyLoader {
		id: launcher
		property bool open: false
		active: open

		PanelWindow {
			anchors.top: true
			anchors.bottom: true
			anchors.left: true
			anchors.right: true

			WlrLayershell.layer: WlrLayershell.Top
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
			exclusionMode: ExclusionMode.Normal

			color: "transparent"
			mask: Region { item: main }

			Rectangle {
				id: main

				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter
				implicitWidth: 400
				implicitHeight: input_bar.implicitHeight + 25 * DesktopEntries.applications.values.length + Appearance.margin * 2

				bottomLeftRadius: 10
				bottomRightRadius: 10
				color: Appearance.primary_color

				NumberAnimation on anchors.topMargin {
					from: -main.implicitHeight
					to: 0
					duration: 500
					easing.type: Easing.InOutQuint
				}

				SequentialAnimation {
					id: byebye

					ParallelAnimation {
						NumberAnimation {
							target: main
							properties: "anchors.topMargin"
							from: 0
							to: -main.implicitHeight
							duration: 500
							easing.type: Easing.InOutQuint
						}

						NumberAnimation {
							target: left_curve
							property: "anchors.topMargin"
							from: 0
							to: -implicitHeight
							duration: 1000
							easing.type: Easing.InOutQuint
						}

						NumberAnimation {
							target: right_curve
							property: "anchors.topMargin"
							from: 0
							to: -implicitHeight
							duration: 1000
							easing.type: Easing.InOutQuint
						}
					}

					PropertyAction {
						target: launcher
						property: "open"
						value: false
					}
				}

				ColumnLayout {
					id: panel
					spacing: 0
					anchors.top: parent.top
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.margins: Appearance.margin
					implicitHeight: input_bar.implicitHeight + apps.contentHeight + Appearance.margin * 2

					Rectangle {
						id: input_bar

						Layout.fillWidth: true
						Layout.preferredHeight: search.implicitHeight + Appearance.margin * 2

						color: Appearance.secondary_color
						radius: 10

						RowLayout {
							id: search

							spacing: 8
							anchors.left: parent.left
							anchors.right: parent.right
							anchors.verticalCenter: parent.verticalCenter
							anchors.margins: Appearance.margin

							Text {
								color: Appearance.text_color
								font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }

								text: ">>"
							}
							TextInput {
								id: input
								
								Layout.fillWidth: true

								focus: true
								clip: true

								color: Appearance.text_color
								font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }

								onAccepted: {
									const entries = DesktopEntries.applications.values
										.map((a) => a.name.toLowerCase().startsWith(input.text.toLowerCase()) ? a : null)
										.sort((a, b) => {
											if (a == null && b == null) return 0;
											if (a == null) return 1;
											if (b == null) return -1;

											if (a.name.length < b.name.length) return -1;
											if (a.name.length > b.name.length) return 1;

											if (a.name < b.name) return -1;
											if (a.name > b.name) return 1;

											return 0;
										})

									entries[0].execute();

									byebye.start();
								}
							}
						}
					}

					ListView {
						id: apps

						spacing: Appearance.margin
						Layout.preferredHeight: contentHeight
						Layout.margins: Appearance.margin 

						model: ScriptModel { 
							values: DesktopEntries.applications.values
								.map((a) => a.name.toLowerCase().startsWith(input.text.toLowerCase()) ? a : null)
								.sort((a, b) => {
									if (a == null && b == null) return 0;
									if (a == null) return 1;
									if (b == null) return -1;

									if (a.name.length < b.name.length) return -1;
									if (a.name.length > b.name.length) return 1;

									if (a.name < b.name) return -1;
									if (a.name > b.name) return 1;

									return 0;
								})
						}

						delegate: Text {
							id: entry

							required property DesktopEntry modelData

							//anchors.horizontalCenter: parent.horizontalCenter

							color: Appearance.text_color
							font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }

							text: modelData.name
						}

						displaced: Transition {
							NumberAnimation {
								property: "y"
								duration: 200
							}
						}

						remove: Transition {
							NumberAnimation {
								property: "opacity"
								to: 0.0
								duration: 200
							}
						}

						add: Transition { 
							NumberAnimation {
								property: "opacity"
								from: 0.0
								to: 1.0
								duration: 200
							}
						}
					}
				}

				Keys.onEscapePressed: {
					byebye.start()
				}
			}
			
			Rectangle {
				id: right_curve

				anchors.top: parent.top
				anchors.left: main.right
				implicitWidth: 50
				implicitHeight: 50

				color: Appearance.primary_color

				layer.enabled: true
				layer.effect: MultiEffect {
					maskEnabled: true
					maskSource: right_mask
					maskInverted: true
					maskThresholdMin: 0.5
					maskSpreadAtMin: 1
				}

				Item {
					id: right_mask
					anchors.fill: parent
					layer.enabled: true
					visible: false 

					Rectangle {
						anchors.fill: parent
						topLeftRadius: 10
					}
				}

				NumberAnimation on anchors.topMargin {
					from: -implicitHeight
					to: 0
					duration: 250
					easing.type: Easing.InOutQuint
				}
			}

			Rectangle {
				id: left_curve
				anchors.top: parent.top
				anchors.right: main.left
				implicitWidth: 50
				implicitHeight: 50
				color: Appearance.primary_color

				layer.enabled: true
				layer.effect: MultiEffect {
					maskEnabled: true
					maskSource: left_mask
					maskInverted: true
					maskThresholdMin: 0.5
					maskSpreadAtMin: 1
				}

				Item {
					id: left_mask
					anchors.fill: parent
					layer.enabled: true
					visible: false 

					Rectangle {
						anchors.fill: parent
						topRightRadius: 10
					}
				}

				NumberAnimation on anchors.topMargin {
					from: -implicitHeight
					to: 0
					duration: 250
					easing.type: Easing.InOutQuint
				}
			}

			MultiEffect {
				anchors.fill: main
				source: main
				shadowEnabled: true
				shadowVerticalOffset: 2
				blurMultiplier: 0.1
				shadowOpacity: 1
			}
		}
	}

	IpcHandler {
		target: "launcher"

		function open() {
			launcher.open = true
		}

		function close() {
			launcher.open = false
		}
	}
}
