{
  config,
  pkgs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nushell";
      simplified_ui = true;
      copy_command = "xclip -selection clipboard";
      layout_dir = "./layouts";
      theme_dir = ".themes";    
    };
  };
} # end