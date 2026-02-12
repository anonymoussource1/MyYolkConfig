import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../ui"

Scope {
	property string current_text
	property string message_text: "You forgot to move your mouse, didn't you?"

	PamContext {
		id: context

		configDirectory: "pam"
		config: "password.conf"

		onPamMessage: {
			if (this.responseRequired) {
				this.respond(current_text)
			}
		}

		onCompleted: result => {
			if (result == PamResult.Success) {
				lock.locked = false;
			} else if (result == PamResult.Failed) {
				message_text = "Wrong password dumbo. Try again."
				reset_text.restart()
			} else if (result == PamResult.MaxTries) {
				message_text = "HA. Restart and try again."
				reset_text.restart()
			}
		}
	}

	Timer {
		id: reset_text
		interval: 4000
		onTriggered: message_text = "You forgot to move your mouse, didn't you?"
	}

	WlSessionLock {
		id: lock

		locked: false

		WlSessionLockSurface {
			Image {
				source: "/home/danielkurz/Backgrounds/bg4.jpg"

				Rectangle {
					id: time

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

				Rectangle {
					anchors.top: time.bottom
					anchors.horizontalCenter: time.horizontalCenter
					anchors.topMargin: 100
					implicitWidth: 420 + 4 * Appearance.margin
					implicitHeight: fields.implicitHeight + 4 * Appearance.margin
					radius: 10

					color: Appearance.primary_color
				
					ColumnLayout {
						id: fields
						anchors.margins: Appearance.margin * 2
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						spacing: Appearance.margin
							
						Rectangle {
							id: message
							implicitWidth: childrenRect.width
							implicitHeight: childrenRect.height
							color: "transparent"

							Text {
								text: message_text

								font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }
								color: message_text == "You forgot to move your mouse, didn't you?" ? Appearance.text_color : "#DA2E2F"

								Behavior on text {
									NumberAnimation {
										target: message
										property: "opacity"
										from: 0
										to: 1
										duration: 250
									}
								}
							}
						}

						Rectangle { 
							id: button

							Layout.fillWidth: true
							implicitHeight: input.height + 2 * Appearance.margin
							radius: 10

							color: Appearance.secondary_color

							TextInput {
								id: input

								clip: true
								focus: true

								anchors.left: parent.left
								anchors.right: parent.right
								anchors.verticalCenter: parent.verticalCenter
								anchors.leftMargin: Appearance.margin
								anchors.rightMargin: Appearance.margin

								echoMode: TextInput.Password

								font { pointSize: 11; family: "BigBlueTermPlusNerdFont" }
								color: Appearance.text_color

								onAccepted: {
									current_text = text
									text = ""
									context.start()
								}

								Keys.onEscapePressed: text = ""
							}
						}

					}
				}

				SystemClock {
					id: clock
					precision: SystemClock.Seconds
				}
			}
		}
	}

	IpcHandler {
		target: "locker"

		function lock() {
			lock.locked = true;
		}

		function unlock() {
			lock.locked = false;
		}
	}
}
