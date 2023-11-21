#!/bin/bash

case $1 in
    interactive)
        echo "Spawning shell"
        docker compose kill schedule_web
        docker compose run -p 4000:4000 schedule_web
        ;;
    run)
        echo "Running App"
        docker compose run -d -p 4000:4000 schedule_web
        docker compose exec -e "PORT=4000" schedule_web iex -S mix phx.server
        ;;
    build)
        echo "Building"
        docker compose build
        ;;
    delete)
        echo "Are you sure you want to delete all docker images? (y/n)"
        read response
        
        if [ "$response" == "y" ]; then
            echo "Cleaning docker images"
                docker rm -f $(docker ps -aq); docker rmi -f $(docker images -aq)
        elif [ "$response" == "n" ]; then
                echo "Operation aborted."
        else
                echo "Invalid response. Please type 'y' or 'n'."
fi
        ;;
    *)
        echo "Usage: $0 {interactive|run|build|delete}"
        exit 1
        ;;
esac
