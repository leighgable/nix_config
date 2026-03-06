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

# environment.systemPackages = [
#    (pkgs.emacsWithPackagesFromUsePackage {
#      package = pkgs.emacs-unstable-nox;
#      config = ./emacs.el;
#    })
#  ];

programs.nvf = {
  enable = true;
  settings.vim = {
    theme.enable = true;
    theme.name = "gruvbox";
    theme.style = "dark";
    statusline.lualine.enable = true;
    telescope.enable = true;
    viAlias = true;
    vimAlias = true;
    lsp.enable = true;
    autocomplete.nvim-cmp.enable = true;
    options.tabstop = 2;
    treesitter = { 
      enable = true;
      autotagHtml = true; 
      addDefaultGrammars = true;
      context.enable = true;
      };
      extraPlugins = { 
        parinfer = {
          package = pkgs.vimPlugins.parinfer-rust;
        };
        ts-rainbow = { 
          package = pkgs.vimPlugins.rainbow-delimiters-nvim;
          setup = "require('rainbow-delimiters.setup').setup()";
        };
        futhark = {
          package = pkgs.vimPlugins.futhark-vim;
        };
      };
    languages = {
      nix.enable = true;
      rust.enable = true;
      bash.enable = true;
      python = { 
        enable = true;
        lsp = {
          enable = true;
          servers = [ "python-lsp-server" ];
        };
        format = { 
          enable = true;
          type = [ "ruff" ];
        };
      };
      clang = {
        enable = true;
        lsp.enable = true;
        lsp.servers = [ "clangd" ];
      };
      ts.enable = true;  
      enableTreesitter = true;
      enableLSP = true;
    };
  };
};
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cups-filters pkgs.cups-browsed ];
  services.ipp-usb.enable = true;
  

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-ocl ];
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
