# hmjn mise config

Arch Linux (CachyOS) 用のユーザー環境を mise で bootstrap する設定です。
パッケージは pacman、AUR パッケージは paru、設定ファイルは `dotfiles/` で管理します。

## Initial setup

package-plugin 対応版の `mise` を用意し、リポジトリのルートから実行します。
`mise` 自体も `aqua:jdx/mise` としてこの設定で管理します。
`paru` 本体は `pacman:paru` として先に導入されます。

```sh
mise trust
mise -E personal bootstrap --dry-run
mise -E personal run setup
```

`--force-dotfiles` は既存の whole-file dotfiles を置き換えます。初回は必ず
dry-run の出力を確認し、必要な設定ファイルをバックアップしてから実行してください。
より慎重に進める場合は、パッケージだけを先に適用できます。

## Profiles

共通の基本環境は `mise.toml`、個人用の Hyprland・GUI・AUR パッケージは
`mise.personal.toml`、仕事用のツールは `mise.work.toml` に分けています。
`.zprofile` は `personal` をデフォルトにします。仕事用へ切り替える場合は
`-E work` を指定してください。

```sh
mise -E personal bootstrap --yes
mise -E work install
mise -E work run setup
```

環境ファイルは `mise.<env>.toml` として共通設定に追加・上書きされます。

```sh
mise -E personal bootstrap plugins apply --yes
mise -E personal bootstrap packages apply --manager pacman --yes
mise -E personal bootstrap packages apply --manager paru --yes
mise -E personal bootstrap repos apply --yes
mise -E personal bootstrap dotfiles apply --force --yes
```

## Hyprland

Hyprland 0.55+ uses native Lua configuration. The entrypoint is
`dotfiles/.config/hypr/hyprland.lua`; the monitor, options, autostart, and
keybindings are split into `config/*.lua` modules with `require()`.

## Host differences

Hyprland の monitor 設定は汎用の `output="", mode="highres"` にしています。
Dell の固定 monitor 配置や ThinkPad 固有の設定が必要になった場合は、
`dotfiles/.config/hypr/config/monitors.lua` をホストごとに調整します。

`hyprpaper` と `swayosd-server` は systemd user unit ではなく、Hyprland の
`hyprland.start` イベントから起動します。Wayland セッション前に起動して
クラッシュループになるのを防ぐためです。

Hyprland の終了は `hyprshutdown` を使い、Wayland client を先に正常終了させます。

旧 `~/.config/hypr/hyprland.conf` は mise の管理対象から外しています。
Lua 設定で正常に起動できることを確認してから、残っている旧 symlink を
手動で片付けてください。

## AUR

`plugins/paru/` は mise の package plugin です。`mise.toml` の
`[bootstrap.packages]` に通常の package manager と同じ感覚で
`"paru:google-chrome" = "latest"` のように宣言できます。

```sh
mise -E personal bootstrap packages apply --manager paru --yes
mise -E personal bootstrap packages upgrade --manager paru --yes
```

plugin は `paru -Q` で状態を確認し、`paru -S --needed --noconfirm` で
宣言されたパッケージだけを処理します。mise の package-plugin API v1 では
uninstall/prune は未対応なので、削除は `paru -Rns` を手動で実行してください。

ローカル plugin は `[bootstrap.plugins]` で宣言的に登録します。

Hyprland の設定は live symlink ではなく copy mode で管理します。personal profile の
dotfile 適用前には `Hyprland --verify-config` を実行し、構文エラーがあれば適用を中止します。
手動で検証・反映する場合は次の task を使います。

```sh
mise -E personal run check-hyprland
mise -E personal bootstrap dotfiles apply --force --yes
```
