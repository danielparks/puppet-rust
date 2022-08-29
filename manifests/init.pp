# @summary Manage a user’s Rust installation with `rustup`
#
# The name should be the username.
#
# @example Standard usage
#   rustup { 'daniel': }
#
# @param ensure
#   * `present` - install rustup, but don’t update it.
#   * `latest` - install rustup and update it on every puppet run.
#   * `absent` - uninstall rustup and the tools it manages.
# @param user
#   The user to own and manage rustup.
# @param home
#   The user’s home directory. This defaults to `/home/$user` on Linux and
#   `/Users/$user` on macOS.
# @param rustup_home
#   Where toolchains are installed. Generally you shouldn’t change this.
# @param cargo_home
#   Where `cargo` installs executables. Generally you shouldn’t change this.
# @param modify_path
#   Whether or not to let `rustup` modify the user’s `PATH` in their shell init
#   scripts. This only affects the initial installation and removal.
# @param installer_source
#   URL of the rustup installation script. Changing this will have no effect
#   after the initial installation.
define rustup (
  Enum[present, latest, absent] $ensure           = present,
  String[1]                     $user             = $name,
  Stdlib::Absolutepath          $home             = rustup::home($user),
  Stdlib::Absolutepath          $rustup_home      = "${home}/.rustup",
  Stdlib::Absolutepath          $cargo_home       = "${home}/.cargo",
  Boolean                       $modify_path      = true,
  Stdlib::HTTPUrl               $installer_source = 'https://sh.rustup.rs',
) {
  include rustup::ordering

  rustup_internal { $name:
    ensure           => $ensure,
    user             => $user,
    home             => $home,
    rustup_home      => $rustup_home,
    cargo_home       => $cargo_home,
    modify_path      => $modify_path,
    installer_source => $installer_source,
  }
}
