export HISTCONTROL=ignoreboth:erasedup
export POSH_THEME=~/.poshthemes/jdyun-original.omp.json
export VIMSPECTOR_PATH=~/.local/share/nvim/site/pack/packer/start/vimspector
export NVIM_PATH=~/.config/nvim
source ~/Scripts/all.sh

if command_exist oh-my-posh; then
	eval "$(oh-my-posh --init --shell bash --config "${POSH_THEME}")"
fi
