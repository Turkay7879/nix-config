{
  description = "MBP nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
	  pkgs.brave
	  pkgs.spotify
	  pkgs.telegram-desktop
	  pkgs.qbittorrent
	  pkgs.tailscale
	  pkgs.aldente
	  pkgs.chatgpt
	  pkgs.jetbrains.idea-ultimate
	  pkgs.jetbrains.pycharm-professional
	  pkgs.vscode
	  pkgs.postman
	  pkgs.dbeaver-bin
	  pkgs.docker
	  pkgs.wireshark
	  pkgs.realvnc-vnc-viewer
        ];

      homebrew = {
	enable = true;
	casks = [
	  "mimestream"
	  "parallels"
	  "balenaetcher"
	  "mac-mouse-fix"
	  "imazing"
	  "royal-tsx"
	  "postgres-unofficial"
	  "openvpn-connect"
	  "firefox"
	  "sublime-text"
	  "android-studio"
	  "anydesk"
	  "microsoft-teams"
	];
	masApps = {
	  "WhatsApp" = 310633997;
	  "Word" = 462054704;
	  "Excel" = 462058435;
	  "PowerPoint" = 462062816;
	  "Windows App" = 1295203466;
	  "Kaspersky VPN" = 1208561404;
	  "Unarchiver" = 425424353;
	  "Xcode" = 497799835;
	  "Outlook" = 985367838;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      system.defaults = {
	finder.AppleShowAllExtensions = true;
	finder.FXEnableExtensionChangeWarning = false;
	finder.FXPreferredViewStyle = "clmv";
	finder.NewWindowTarget = "Home";
	finder.ShowPathbar = true;

	loginwindow.GuestEnabled = false;

	NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
	NSGlobalDomain."com.apple.sound.beep.feedback" = 1;
	
	SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
	
	trackpad.ActuationStrength = 0;
	trackpad.Clicking = true;
	trackpad.FirstClickThreshold = 0;
	trackpad.SecondClickThreshold = 0;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
      	configuration
	mac-app-util.darwinModules.default
	nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = "turkay";

	    # Automatically migrate existing Homebrew installations
            # autoMigrate = true;
          };
        }
      ];
    };
  };
}
