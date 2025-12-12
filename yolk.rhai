export let data = #{
	device_type: if SYSTEM.hostname.ends_with("desktop") {
		"desktop"
	} else if SYSTEM.hostname.ends_with("laptop") {
		"laptop"
	},
};

let zen_profile = io::read_file("zen_profile");
export let eggs = #{
	eww: #{ targets: "~/.config/eww" },
	kitty: #{ targets: "~/.config/kitty" },
	vim: #{ targets: "~/.config/vim" },
	bash: #{ targets: "~", strategy: "merge" },
	sway: #{ targets: "~/.config/sway", templates: ["config"] },
	zen: #{ targets: "~/.var/app/app.zen_browser.zen/.zen/" + zen_profile.sub_string(0..(zen_profile.len() - 1)) + "/chrome", strategy: "merge" },
	homemanager: #{ targets: "~/.config/home-manager" }
}
