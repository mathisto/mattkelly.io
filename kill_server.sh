#!/bin/bash

# kill_server.sh - Stop all Rails server and background job processes
# Stops everything started by bin/dev (Puma, SolidQueue, Foreman)

echo "🔍 Searching for running processes..."
echo ""

# Find and kill Puma (Rails server)
PUMA_PIDS=$(pgrep -f "puma.*mattkelly.io")
if [ -n "$PUMA_PIDS" ]; then
  echo "🛑 Stopping Puma (Rails server)..."
  echo "$PUMA_PIDS" | while read pid; do
    echo "  Killing PID $pid"
    kill $pid 2>/dev/null || kill -9 $pid 2>/dev/null
  done
else
  echo "✓ No Puma process found"
fi

# Find and kill SolidQueue processes (supervisor, worker, dispatcher)
SOLID_PIDS=$(pgrep -f "solid-queue")
if [ -n "$SOLID_PIDS" ]; then
  echo "🛑 Stopping SolidQueue (background jobs)..."
  echo "$SOLID_PIDS" | while read pid; do
    ps -p $pid -o pid,command | grep -v "PID"
    kill $pid 2>/dev/null || kill -9 $pid 2>/dev/null
  done
else
  echo "✓ No SolidQueue processes found"
fi

# Find and kill Foreman (process manager from bin/dev)
FOREMAN_PIDS=$(pgrep -f "foreman.*Procfile.dev")
if [ -n "$FOREMAN_PIDS" ]; then
  echo "🛑 Stopping Foreman (process manager)..."
  echo "$FOREMAN_PIDS" | while read pid; do
    echo "  Killing PID $pid"
    kill $pid 2>/dev/null || kill -9 $pid 2>/dev/null
  done
else
  echo "✓ No Foreman process found"
fi

# Find and kill any bin/dev shell wrapper processes
DEV_PIDS=$(pgrep -f "bin/dev")
if [ -n "$DEV_PIDS" ]; then
  echo "🛑 Stopping bin/dev wrapper processes..."
  echo "$DEV_PIDS" | while read pid; do
    echo "  Killing PID $pid"
    kill $pid 2>/dev/null || kill -9 $pid 2>/dev/null
  done
else
  echo "✓ No bin/dev processes found"
fi

# Find and kill any Rails server processes (fallback)
RAILS_PIDS=$(pgrep -f "rails server")
if [ -n "$RAILS_PIDS" ]; then
  echo "🛑 Stopping Rails server processes..."
  echo "$RAILS_PIDS" | while read pid; do
    echo "  Killing PID $pid"
    kill $pid 2>/dev/null || kill -9 $pid 2>/dev/null
  done
else
  echo "✓ No Rails server processes found"
fi

echo ""
echo "✅ All processes stopped!"
echo ""
echo "To start again, run: bin/dev"
echo ""

# Give processes a moment to shut down
sleep 1

# Show any remaining processes (for verification)
REMAINING=$(ps aux | grep -E "(puma|solid-queue|foreman|rails server)" | grep -v grep | grep -v kill_server)
if [ -n "$REMAINING" ]; then
  echo "⚠️  Warning: Some processes may still be running:"
  echo "$REMAINING"
  echo ""
  echo "Run this script again or use: kill -9 <PID>"
else
  echo "✓ All clear - no processes remaining"
fi
