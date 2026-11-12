export ZOXIDE_CMD_OVERRIDE="cd"
# Agent shells (Claude Code, opencode, ...) snapshot functions but not zoxide's
# chpwd hook, so `zoxide doctor` warned on every cd there. Silence the check.
export _ZO_DOCTOR=0
plugins+=(zoxide)
