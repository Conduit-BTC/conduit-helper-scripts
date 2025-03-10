#!/bin/bash
# start-dev.sh

# Check if Docker daemon is running
if ! docker ps &>/dev/null; then
    echo "Docker daemon isn't running. Can't start the stack."
    exit 1
fi

# Check if tmux session already exists
if tmux has-session -t conduit 2>/dev/null; then
    echo "Connecting to existing tmux session 'conduit'..."
    tmux attach-session -t conduit
    exit 0
fi

# Create new tmux session if none exists
echo "Creating new tmux session 'conduit'..."
tmux new-session -d -s conduit

# Create windows for each service
tmux new-window -t conduit:1 -n coordinator
tmux send-keys -t conduit:1 'cd a-nostr-commerce-coordinator && c. && bun run dev' C-m

tmux new-window -t conduit:2 -n merchant-x
tmux send-keys -t conduit:2 'cd merchant-x && c. && bun run dev' C-m

tmux new-window -t conduit:3 -n strfry
tmux send-keys -t conduit:3 'cd strfry && docker-compose up' C-m

tmux new-window -t conduit:4 -n lmdb-maestro-client
tmux send-keys -t conduit:4 'cd ./utils/lmdb-maestro && bun run dev' C-m

tmux new-window -t conduit:5 -n lmdb-maestro-server 
tmux send-keys -t conduit:5 'cd ./utils/lmdb-maestro && bun run dev:server' C-m

tmux new-window -t conduit:6 -n relay-maestro
tmux send-keys -t conduit:6 'cd ./utils/relay-maestro && bun run dev' C-m

tmux new-window -t conduit:7 -n market-client
tmux send-keys -t conduit:7 'cd ./conduit-market-client && c. && bun run dev' C-m

# Select the first window and attach to the session
tmux select-window -t conduit:1
tmux attach-session -t conduit
