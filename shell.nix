{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
	buildInputs = [
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
}
