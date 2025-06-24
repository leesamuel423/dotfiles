#!/bin/bash

# Exit if tmux session already exists
tmux has-session -t quartz-dev 2>/dev/null
if [ $? -eq 0 ]; then
    echo "tmux session 'quartz-dev' already exists. Attaching..."
    tmux attach-session -t quartz-dev
    exit 0
fi

# Create new tmux session
tmux new-session -d -s quartz-dev

# Pane 1: Frontend
tmux send-keys -t quartz-dev:0.0 "cd ~/quartz/quartz-frontend" C-m
tmux send-keys -t quartz-dev:0.0 "set -a && source .env && set +a" C-m
tmux send-keys -t quartz-dev:0.0 "make dev" C-m

# Split window horizontally for Supabase
tmux split-window -h -t quartz-dev:0

# Pane 2: Supabase
tmux send-keys -t quartz-dev:0.1 "cd ~/quartz/quartz-supabase" C-m
tmux send-keys -t quartz-dev:0.1 "make run-local" C-m

# Wait for containers to start (adjust time if needed)
tmux send-keys -t quartz-dev:0.1 "sleep 30 && make seed-alerts && ./scripts/run-cron-setup.sh" C-m

# Set pane titles
tmux select-pane -t quartz-dev:0.0 -T "Frontend"
tmux select-pane -t quartz-dev:0.1 -T "Supabase"

# Attach to the session
tmux attach-session -t quartz-dev