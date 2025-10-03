{ config, pkgs, lib, ... }:

{
	imports = [
		~/.config/sway/config.nix
	];

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
		kdePackages.okular
		(flameshot.override { enableWlrSupport = true; })
		(eww.overrideAttrs (oldAttrs: rec {
			patches = [
				~/.config/eww/patches/patch.diff
			];
		}))
		(pkgs.rustPlatform.buildRustPackage rec {
			pname = "yolk_dots";
			version = "0.3.4";
			src = pkgs.fetchFromGitHub {
				owner = "elkowar";
				repo = "yolk";
				rev = "main";
				hash = "sha256-3EQ6w+Jv/Fq5wJMit5lHUVfzcPmtySitGD83Hl4jfJY=";
			};
		
			cargoHash = "sha256-NsWdkvrMqhl3wwreBUjo5rRHA7W2NVkyWkT5Cr3qftA=";
			doCheck = false;
		})	
	];

	programs.bash = {
		enable = true;
		profileExtra = ''
			. ~/.bash_prompt
			sway
		'';
	};

	/*home.pointerCursor = 
		let 
			getFrom = url: hash: name: {
				sway.enable = true;
				name = name;
				size = 48;
				package = pkgs.runCommand "moveUp" {} ''
					mkdir -p $out/share/icons
					ln -s ${pkgs.fetchzip {
						url = url;
						hash = hash;
					}} $out/share/icons/${name}
					'';
			};
		in getFrom 
			"https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
			"sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
			"Fuchsia-Pop";
*/

	
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
