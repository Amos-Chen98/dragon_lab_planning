#!/usr/bin/env bash
set -uo pipefail

# Define the list of spawn configurations (plan)
# Each line represents: spawn_x spawn_y spawn_yaw
declare -a configs=(
    "-1.0 -1.0 1.57"
    "-1.1 -1.0 1.57"
    "-1.2 -1.0 1.57"
    "-1.3 -1.0 1.57"
    "-1.4 -1.0 1.57"
)

echo "Starting batch simulations with ${#configs[@]} configurations..."

# Loop through each configuration
for config in "${configs[@]}"; do
    # Parse the configuration into variables
    read -r spawn_x spawn_y spawn_yaw <<< "$config"
    
    echo "=========================================="
    echo "Running simulation with:"
    echo "  SPAWN_X: $spawn_x"
    echo "  SPAWN_Y: $spawn_y"
    echo "  SPAWN_YAW: $spawn_yaw"
    echo "=========================================="
    
    # Call the simulation script with the current configuration
    ./run_simulation.sh "$spawn_x" "$spawn_y" "$spawn_yaw"

    # Wait 20 seconds to ensure all previous threads are killed
    sleep 20
    
    echo ""
done

echo "All batch simulations completed."
