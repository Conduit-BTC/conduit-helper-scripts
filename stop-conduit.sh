#!/bin/bash
# stop-dev.sh

# Check if the tmux session exists
if tmux has-session -t conduit 2>/dev/null; then
    # Send Ctrl-C to each window to gracefully stop processes
    for i in {1..3}; do
        tmux send-keys -t conduit:$i C-c
    done
    
    # Kill the tmux session
    tmux kill-session -t conduit
    echo "Development environment stopped"
else
    echo "No development session found"
fi
