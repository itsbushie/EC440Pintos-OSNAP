unalias pintos 2> /dev/null

function pintos_legacy {
    # Collect all IPv4 addresses seen by the device
    local addresses=($(ipconfig | grep "IPv4 Address" | awk '{print $NF}' | grep -v "127.0.0.1"))

    if [[ ${#addresses[@]} -eq 0 ]]; then
        echo "Error: No IPv4 Address found"
        return 1
    fi

    # If more than one, ask user
    local ipv4_address
    if [[ ${#addresses[@]} -gt 1 ]]; then
        echo "Multiple IPv4 addresses detected:"
        local i=1
        for addr in "${addresses[@]}"; do
            echo "  [$i] $addr"
            ((i++))
        done
        read -p "Select which one to use: " choice
        ipv4_address=${addresses[$((choice-1))]}
    else
        ipv4_address=${addresses[0]}
    fi

    # Repo path for pintos 
    local repo_path="$(cygpath -u "$USERPROFILE")/pintos"
    export DISPLAY="${ipv4_address}:0.0"
    local bxshare='/home/BUOS/toolchain/x86_64/share/bochs'
    #local environment variables so bochs can actually work
    local pintos_bin='/home/BUOS/toolchain/x86_64/bin'

    echo ""
    echo "IP set to: ${DISPLAY}"
    echo "Docker mounted to: $repo_path"
    echo "VcxSrv linked to DISPLAY"
    echo "Type in this command at startup inside pintos: source setup.sh"
    echo ""

    docker run -it --rm --name pintos \
        --mount type=bind,source="$repo_path",target=/home/BUOS/pintos \
        -e DISPLAY="${DISPLAY}" \
        -e BXSHARE="${bxshare}" \
        buec440/pintos //bin/bash
}

unalias pintos 2> /dev/null

function pintos {
    # Check if a container named 'pintos' is already running
    local existing_container=$(docker ps -q -f "name=pintos")

    if [[ -n "$existing_container" ]]; then
        echo "A container named 'pintos' is already running."
        # Prompt the user for what to do next
        read -p "Open a new terminal session in it? [Y/n] " choice
        
        # Default to "Y" if the user just presses Enter
        case "$choice" in
            n|N )
                echo "Ok, doing nothing."
                return 0
                ;;
            * )
                echo "Connecting to the existing container..."
                docker exec -it pintos bash
                return 0
                ;;
        esac
    fi

    # --- The following code only runs if no 'pintos' container is found ---
    
    echo "No running 'pintos' container found. Starting a new one..."

    # Collect all IPv4 addresses seen by the device
    local addresses=($(ipconfig | grep "IPv4 Address" | awk '{print $NF}' | grep -v "127.0.0.1"))

    if [[ ${#addresses[@]} -eq 0 ]]; then
        echo "Error: No IPv4 Address found"
        return 1
    fi

    # If more than one, ask user
    local ipv4_address
    if [[ ${#addresses[@]} -gt 1 ]]; then
        echo "Multiple IPv4 addresses detected:"
        local i=1
        for addr in "${addresses[@]}"; do
            echo "  [$i] $addr"
            ((i++))
        done
        read -p "Select which one to use: " choice
        ipv4_address=${addresses[$((choice-1))]}
    else
        ipv4_address=${addresses[0]}
    fi

    # Repo path for pintos 
    local repo_path="$(cygpath -u "$USERPROFILE")/pintos"
    export DISPLAY="${ipv4_address}:0.0"
    local bxshare='/home/BUOS/toolchain/x86_64/share/bochs'
    #local environment variables so bochs can actually work
    local pintos_bin='/home/BUOS/toolchain/x86_64/bin'

    echo ""
    echo "IP set to: ${DISPLAY}"
    echo "Docker mounted to: $repo_path"
    echo "VcxSrv linked to DISPLAY"
    echo "Type in this command at startup inside pintos: source setup.sh"
    echo ""

    # Run a new container. Note that --rm has been removed.
    docker run -it --rm --name pintos \
        --mount type=bind,source="$repo_path",target=/home/BUOS/pintos \
        -e DISPLAY="${DISPLAY}" \
        -e BXSHARE="${bxshare}" \
        buec440/pintos //bin/bash
}