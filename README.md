# hmjn mise config

Arch Linux (CachyOS) 用のユーザー環境を mise で bootstrap する設定です。

このリポジトリは、旧 `nix-config` の Home Manager 設定から移植したものです。
パッケージは pacman、AUR パッケージは paru、設定ファイルは `dotfiles/` で管理します。

## Initial setup

package-plugin 対応版の `mise` を用意し、リポジトリのルートから実行します。
`paru` 本体は `pacman:paru` として先に導入されます。

```sh
mise trust
mise bootstrap --dry-run
mise bootstrap --yes --force-dotfiles
```

`--force-dotfiles` は既存の whole-file dotfiles を置き換えます。初回は必ず
dry-run の出力を確認し、必要な設定ファイルをバックアップしてから実行してください。
より慎重に進める場合は、パッケージだけを先に適用できます。

```sh
mise bootstrap plugins apply --dry-run
mise bootstrap plugins apply
mise bootstrap packages apply --manager pacman --yes
mise bootstrap repos apply --yes
mise bootstrap dotfiles apply --force --yes
mise bootstrap linux systemd-units apply --yes
mise bootstrap packages apply --manager paru --yes
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

`plugins/paru/` は mise の package plugin です。`mise.toml` の
`[bootstrap.packages]` に通常の package manager と同じ感覚で
`"paru:google-chrome" = "latest"` のように宣言できます。

```sh
mise bootstrap plugins status
mise bootstrap packages status --manager paru
mise bootstrap packages apply --manager paru --yes
mise bootstrap packages upgrade --manager paru --yes
```

plugin は `paru -Q` で状態を確認し、`paru -S --needed --noconfirm` で
宣言されたパッケージだけを処理します。mise の package-plugin API v1 では
uninstall/prune は未対応なので、削除は `paru -Rns` を手動で実行してください。

`[bootstrap.plugins]` は現在このリポジトリの絶対パスを指しています。リポジトリを
別の場所へ移動した場合は `mise.toml` の plugin path を更新してください。

手元の mise `2026.7.5` には package-plugin 用の bootstrap CLI がまだありません。
その版で `mise bootstrap` を実行した場合は、`bootstrap` task が互換 fallback として
`mise run aur` を自動実行します。

## Legacy repository

元の Nix 設定は `/home/hmjn/nix-config` に残しています。移行確認が終わるまでは
削除せず、ログインシェルや Hyprland の不具合時の比較用に利用できます。
