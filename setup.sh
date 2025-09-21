# ~/pintos/pintos_setup.sh

# --- Welcome Message ---
echo "🚀 Welcome to the custom Pintos environment!"
echo ""

# --- Custom Functions ---
# A simple function to list project directories
export BXSHARE=/home/BUOS/toolchain/x86_64/share/bochs
echo "BXSHARE set to: /home/BUOS/toolchain/x86_64/share/bochs"

# --- Custom Prompt ---
# This sets a custom color prompt to make it obvious you're in the container
export PS1='\[\033[01;32m\]\u@pintos-docker\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

