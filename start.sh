#!/bin/bash

# Default values
LOCAL=false
PROFILE=""

# Help message
usage() {
    echo "Usage: $0 <lab> [--local] or $0 --lab <lab> [--local]"
    echo "  <lab>   (Required) Lab name to use"
    echo "  --local (Optional) Run with local compose file"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --lab)
            PROFILE="$2"
            shift 2
            ;;
        --local)
            LOCAL=true
            shift
            ;;
        -*)
            echo "Unknown argument: $1"
            usage
            ;;
        *)
            # If PROFILE is empty, assume the first positional argument is the profile
            if [[ -z "$PROFILE" ]]; then
                PROFILE="$1"
                shift
            else
                echo "Unexpected argument: $1"
                usage
            fi
            ;;
    esac
done

# Ensure profile is provided
if [[ -z "$PROFILE" ]]; then
    echo "Error: A lab name is required."
    usage
fi


# Run the appropriate Docker Compose command
if $LOCAL; then
    echo "Building from local Dockerfiles (Lab: $PROFILE)..."
    docker compose -f docker-compose.local.yaml --profile "$PROFILE" up -d --build
else
    echo "Building from remote images (Lab: $PROFILE)..."
    docker compose -f docker-compose.yaml --profile "$PROFILE" up -d --build
fi