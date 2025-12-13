{ config, pkgs, lib, ... }:

{
	# Home Manager needs a bit of information about you and the paths it should
	# manage.
	home.username = "danielkurz";
	home.homeDirectory = "/home/danielkurz";

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "23.11"; # Please read the comment before changing.
	
	# The home.packages option allows you to install Nix packages into your
	# environment.
	nixpkgs.config.allowUnfree = true;
	home.packages = with pkgs; [
		# # Adds the 'hello' command to your environment. It prints a friendly
		# # "Hello, world!" when run.
		# pkgs.hello
		
		# # It is sometimes useful to fine-tune packages, for example, by applying
		# # overrides. You can do that directly here, just don't forget the
		# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
		# # fonts?
		# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
		
		# # You can also create simple shell scripts directly inside your
		# # configuration. For example, this adds a command 'my-hello' to your
		# # environment:
		# (pkgs.writeShellScriptBin "my-hello" ''
		#   echo "Hello, ${config.home.username}!"
		# '')
		tree
		i3blocks
		cargo
		rustc
		bc
		gimp3
		dex
		cowsay
		spotify
		kdePackages.okular
		playerctl
		quickshell
		(eww.overrideAttrs (oldAttrs: rec {
			patches = [
				~/.config/eww/patches/patch.diff
			];
		}))
		(rustPlatform.buildRustPackage rec {
			pname = "yolk_dots";
			version = "0.3.4";
			src = fetchFromGitHub {
				owner = "elkowar";
				repo = "yolk";
				rev = "main";
				hash = "sha256-VkiFG+rMr39PN12ACxVRXOz4aOenFhP+rIfZmPTCi0s=";
			};
		
			cargoHash = "sha256-/ePCdk75xAq+JQFsgW2+ZUodQrZyYYbHYfSYP+of0Og=";
			doCheck = false;
		})	
	];
	
	services.swayidle = let 
		lock = "${pkgs.swaylock}/bin/swaylock -feF -i ~/Backgrounds/bg.jpg --font BigBlueTermPlusNerdFont";
		display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
	in {
		enable = true;
		timeouts = [
			{ timeout = 60; command = lock; }
			{ timeout = 120; command = display "off"; resumeCommand = display "on"; }
			{ timeout = 135; command = "systemctl suspend"; }
		];
		events = [
			{ event = "before-sleep"; command = lock; }
		];
	};

	programs.bash = {
		enable = true;
		profileExtra = ''
			. ~/.bash_prompt
		'';
	};

	home.pointerCursor = {
		enable = true;
		name = "Bibata-Modern-Classic";
		package = pkgs.bibata-cursors;
		size = 20;
	};
	
	# Home Manager can also manage your environment variables through
	# 'home.sessionVariables'. If you don't want to manage your shell through Home
	# Manager then you have to manually source 'hm-session-vars.sh' located at
	# either
	#
	#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  /etc/profiles/per-user/danielkurz/etc/profile.d/hm-session-vars.sh
	#
	home.sessionVariables = {
		EDITOR = "vim";
		PATH="$PATH:/home/danielkurz/.bin";
		TERMINAL="kitty";
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
