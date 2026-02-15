# Neovim Cheat Sheet

よく使うキー操作を中心にしたメモです。

## General Vim (Normal Mode)

- `h` `j` `k` `l`: 左/下/上/右に移動
- `w` / `b`: 単語単位で前後移動
- `0` / `^` / `$`: 行頭 / 非空白先頭 / 行末へ移動
- `gg` / `G`: ファイル先頭 / 末尾へ移動
- `%`: 対応する括弧へジャンプ
- `f{char}` / `t{char}`: 行内で前方検索して移動
- `F{char}` / `T{char}`: 行内で後方検索して移動
- `;` / `,`: 直前の `f/t/F/T` の検索を次/前候補へ進める
- `Ctrl-f` / `Ctrl-b`: 1ページ進む / 戻る
- `Ctrl-d` / `Ctrl-u`: 半ページ進む / 戻る
- `H` / `M` / `L`: 画面の上 / 中央 / 下へ移動
- `zt` / `zz` / `zb`: 現在行を画面の上 / 中央 / 下に寄せる

## Edit / Undo

- `i` / `a`: 挿入モードへ
- `o` / `O`: 下/上に新しい行を作って挿入
- `x`: 1文字削除
- `dd`: 1行削除
- `dw`: 単語削除
- `yy`: 1行コピー
- `p` / `P`: 貼り付け（後/前）
- `u`: Undo
- `Ctrl-r`: Redo

## Search / Replace

- `/word`: 下方向に検索
- `?word`: 上方向に検索
- `n` / `N`: 次/前の検索結果
- `:%s/old/new/g`: 全体置換
- `:%s/old/new/gc`: 確認しながら置換

## Buffer / Window

- `:ls`: バッファのリスト表示
- `:bnext` / `:bprev`: バッファ切り替え
  - `:bn` / `bp`
- `:b<num>`: バッファ番号で切り替え
- `:bd`: バッファを閉じる
- `:vsplit` / `:split`: 縦/横分割
  - `:vsp` / ':sp'
- `Ctrl-w h/j/k/l`: 分割間の移動

## Useful Ex Commands

- `:w`: 保存
- `:q`: 終了
- `:wq`: 保存して終了
- `:x`: 保存して終了
- `:q!`: 保存せず終了
- `:e!`: ファイルを再読込
- `:set number`: 行番号表示
- `:set relativenumber`: 相対行番号表示

## Built-in LSP Keymaps (Neovim v0.11)

LSP が attach されたバッファで使えるデフォルトキー。

- `K`: Hover（型/ドキュメント表示）
- `grn`: Rename
- `gri`: Implementations（実装へ）
- `grr`: References（参照一覧）
- `gO`: Document Symbols（ファイル内シンボル一覧）
- `Ctrl-s` (Insert mode): Signature help（引数ヒント）
- `]d` / `[d`: 次/前の診断へ移動
- `gl`: カーソル位置の診断を float 表示

## Your Custom Keymaps

`mapleader` は `,`。

- `,e`: `NvimTree` の表示/非表示
- `,dn`: 次の診断へ移動 + エラー内容を float 表示
- `,dp`: 前の診断へ移動 + エラー内容を float 表示
- `,dt`: 診断の `virtual_text` を ON/OFF 切り替え

## Diagnostic / LSP Quick Check

- `:LspInfo`: LSPアタッチ状況を確認
- `:checkhealth`: 環境チェック
