# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # inputs.nvf.nixosModules.default
    ./hardware-configuration.nix
  ];
  home-manager = {
    useGlobalPkgs = true; 
    useUserPackages = true;
    sharedModules = [ ../modules/home-manager ];
    extraSpecialArgs = { inherit inputs; };
    users.leigh = ../home-manager/home.nix; 
  };
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Hack to avoid stall on suspend.
  # systemd.services."pre-sleep".wantedBy = lib.mkForce [ ];
 
  networking.networkmanager.enable = true;
  virtualisation.docker.enable = true;
  # TODO: Set your hostname
  networking.hostName = "think";



  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  programs.nvf = {
    enable = true;
    settings = {
      vim.viAlias = true; 
      vim.vimAlias = true;
      vim.options = {
        tabstop = 2;

      };
      vim.lsp = {
        enable = true;
        };
      vim.languages = {
        nix = {
          enable = true;
          format.enable = true;
          format.type = [ "nixfmt" ];
          lsp.enable = true;
          treesitter.enable = true;
      };
        rust.enable = true;
        rust.lsp.enable = true;
        clang.enable = true;
        clang.lsp.enable = true;
        clang.lsp.servers = [ "clangd" ];
        clang.treesitter.enable = true;
        python = {
          enable = true;
          lsp.enable = true;
          lsp.servers = [ "python-lsp-server" ];
          format.enable = true;
          format.type = [ "ruff" ];
          treesitter.enable = true;
          };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  # hardware.bluetooth.hsphfpd.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

 #  environment.etc = {
	#   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
	# 	  bluez_monitor.properties = {
	# 		  ["bluez5.enable-sbc-xq"] = true,
	# 		  ["bluez5.enable-msbc"] = true,
	# 		  ["bluez5.enable-hw-volume"] = true,
	# 		  ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
	# 	}
	# '';
 #  };
  # bash completion
  environment.pathsToLink = [ "/share/bash-completion" ];

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    leigh = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "ez";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "audio" "networkmanager" "docker" "lp"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
