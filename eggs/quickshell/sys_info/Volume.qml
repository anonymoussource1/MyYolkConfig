pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
	property string percent: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100)
	property bool is_muted: Pipewire.defaultAudioSink?.audio.muted ?? false

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}
}
