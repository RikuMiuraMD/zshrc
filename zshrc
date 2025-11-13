# 機能設定

# 保管機能オン
autoload -U compinit
compinit
# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2


# コマンドミスを修正
setopt correct

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

# ここら下はbranch名を表示させるメソッドの設定-----------------------------
# 参考記事
# https://qiita.com/koki0527/items/ca734df6fa86a8dbd241
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てコミットされてクリーンな状態
    branch_status=""
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status=" !"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status=" *"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status=" +"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red} !!"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status=""
  fi
  # ブランチ名を色付きで表示する
  echo "($branch_name${branch_status})"
}

# プロンプトが表示されるたび、毎回プロンプトの文字列を評価し、置換する
setopt prompt_subst

# ここら下はプロンプトの表示設定-----------------------------
PROMPT='%F{cyan}[%n@%m]%F{white}: %B%~%b `rprompt-git-current-branch`
$ '


# ここまで-------------------------------------------------

# alias
alias ll='ls -la'
alias $=''
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
alias nl='npm run lint:files'
alias nf='npm run format:files'