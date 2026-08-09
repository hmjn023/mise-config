# hmjn mise config

Arch Linux (CachyOS) 用のユーザー環境を mise で bootstrap する設定です。

このリポジトリは、旧 `nix-config` の Home Manager 設定から移植したものです。
パッケージは pacman、AUR パッケージは paru、設定ファイルは `dotfiles/` で管理します。

## Initial setup

`mise` と `paru` が使える状態で、リポジトリのルートから実行します。

```sh
mise trust
mise bootstrap --dry-run
mise bootstrap --yes --force-dotfiles
```

`--force-dotfiles` は既存の whole-file dotfiles を置き換えます。初回は必ず
dry-run の出力を確認し、必要な設定ファイルをバックアップしてから実行してください。
より慎重に進める場合は、パッケージだけを先に適用できます。

```sh
mise bootstrap packages apply --yes
mise bootstrap repos apply --yes
mise bootstrap dotfiles apply --force --yes
mise bootstrap linux systemd-units apply --yes
mise run aur
```

## Hyprland

Hyprland 0.55+ uses native Lua configuration. The entrypoint is
`dotfiles/.config/hypr/hyprland.lua`; the monitor, options, autostart, and
keybindings are split into `config/*.lua` modules with `require()`.

## Host differences

Hyprland の monitor 設定は汎用の `output="", mode="highres"` にしています。
Dell の固定 monitor 配置や ThinkPad 固有の設定が必要になった場合は、
`dotfiles/.config/hypr/config/monitors.lua` をホストごとに調整します。

旧 `~/.config/hypr/hyprland.conf` は mise の管理対象から外しています。
Lua 設定で正常に起動できることを確認してから、残っている Nix 管理の symlink を
手動で片付けてください。

## AUR

`mise bootstrap` の最後に `bootstrap` task が実行され、AUR パッケージを paru で
インストールします。AUR の構築・署名は pacman の外側にあるため、mise の標準
package manager ではなく task として扱っています。

## Legacy repository

元の Nix 設定は `/home/hmjn/nix-config` に残しています。移行確認が終わるまでは
削除せず、ログインシェルや Hyprland の不具合時の比較用に利用できます。
