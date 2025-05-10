#!/bin/bash
# CatFish - A cat-themed URL masking tool for educational purposes
# Use responsibly and only with proper authorization

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"
BOLD="\e[1m"

# Version
VERSION="1.1"

# Check and load configuration
CONFIG_FILE="$HOME/.catfish.conf"

load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        echo -e "${YELLOW}[*] Loading configuration...${RESET}"
        source "$CONFIG_FILE"
        echo -e "${GREEN}[✓] Configuration loaded!${RESET}"
    else
        echo -e "${YELLOW}[!] No configuration file found. Using default settings.${RESET}"

        # Create default config file
        echo -e "${YELLOW}[*] Would you like to create a default configuration file? (y/n)${RESET}"
        echo -en "${GREEN}➤ ${RESET}"
        read create_config

        if [[ "$create_config" == "y" || "$create_config" == "Y" ]]; then
            cat > "$CONFIG_FILE" << EOL
# CatFish Configuration File

# Default URL shortener (isgd, tinyurl, bitly)
DEFAULT_SHORTENER="isgd"

# Bitly API Key (if using Bitly)
# BITLY_API_KEY=""

# Google Safe Browsing API Key (for URL reputation checking)
# SAFE_BROWSING_API_KEY=""

# Always generate QR codes (true/false)
AUTO_GENERATE_QR=false

# Always save to history (true/false)
AUTO_SAVE_HISTORY=false

# Default template (1-5, leave empty for no default)
# DEFAULT_TEMPLATE=""
EOL
            echo -e "${GREEN}[✓] Default configuration created at $CONFIG_FILE${RESET}"
            echo -e "${YELLOW}[!] Edit this file to customize your settings.${RESET}"
        fi
    fi
}

# Function to display help
show_help() {
    echo -e "\n${BOLD}${CYAN}CatFish - A cat-themed URL masking tool${RESET}"
    echo -e "\n${BOLD}Usage:${RESET}"
    echo -e "  ./catfish.sh [options]"
    echo -e "\n${BOLD}Options:${RESET}"
    echo -e "  -h, --help          Show this help message"
    echo -e "  -u, --url URL       Specify the phishing URL"
    echo -e "  -m, --mask URL      Specify the mask domain"
    echo -e "  -w, --words WORDS   Specify the bait words"
    echo -e "  -q, --qr            Generate QR code"
    echo -e "  -s, --save          Save URL to history"
    echo -e "\n${BOLD}Example:${RESET}"
    echo -e "  ./catfish.sh -u http://example.com -m https://facebook.com -w cute-kittens -q -s"
    echo -e "\n${BOLD}Note:${RESET}"
    echo -e "  This tool is for educational purposes only.\n"
    exit 0
}

# Function to validate URL format
validate_url() {
    if [[ ! "${1//:*}" = http && ! "${1//:*}" = https ]]; then
        echo -e "${RED}[!] Invalid URL. Please use http or https.${RESET}"
        return 1
    fi
    return 0
}

# Check dependencies
check_dependencies() {
    local missing=false

    echo -e "\n${BOLD}${CYAN}[*] Checking dependencies...${RESET}"

    if ! command -v curl &> /dev/null; then
        echo -e "${RED}[!] curl is not installed. Required for URL shortening.${RESET}"
        missing=true
    fi

    if [ "$missing" = true ]; then
        echo -e "${YELLOW}[!] Some dependencies are missing. Install them? (y/n)${RESET}"
        echo -en "${GREEN}➤ ${RESET}"
        read install_deps
        if [[ "$install_deps" == "y" || "$install_deps" == "Y" ]]; then
            apt-get update && apt-get install -y curl
            if [ $? -ne 0 ]; then
                echo -e "${RED}[!] Failed to install dependencies. Exiting.${RESET}"
                exit 1
            fi
            echo -e "${GREEN}[✓] Dependencies installed successfully!${RESET}"
        else
            echo -e "${RED}[!] Cannot continue without required dependencies. Exiting.${RESET}"
            exit 1
        fi
    else
        echo -e "${GREEN}[✓] All dependencies are installed!${RESET}"
    fi
}

# Check if qrencode is installed
check_qrencode() {
    if ! command -v qrencode &> /dev/null; then
        echo -e "${YELLOW}[!] qrencode not found. Would you like to install it? (y/n)${RESET}"
        echo -en "${GREEN}➤ ${RESET}"
        read install_choice
        if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
            apt-get update && apt-get install -y qrencode
            if [ $? -ne 0 ]; then
                echo -e "${RED}[!] Failed to install qrencode. QR code generation will be skipped.${RESET}"
                return 1
            fi
        else
            return 1
        fi
    fi
    return 0
}

# Function to check for updates
check_for_updates() {
    echo -e "\n${BOLD}${CYAN}[*] Checking for updates...${RESET}"

    # This is a placeholder. In a real implementation, you'd need to:
    # 1. Host your script somewhere (like GitHub)
    # 2. Have a version file or way to check the latest version
    # 3. Compare local version with remote version

    # Example using GitHub:
    if command -v curl &> /dev/null && command -v grep &> /dev/null; then
        # Set your GitHub repository information
        REPO_USER="your-username"
        REPO_NAME="catfish"

        # Define the current version (you'd need to add this to your script)
        CURRENT_VERSION="1.0"

        # Try to get the latest version from GitHub
        LATEST_VERSION=$(curl -s "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/version.txt" || echo "unknown")

        if [[ "$LATEST_VERSION" != "unknown" && "$LATEST_VERSION" != "$CURRENT_VERSION" ]]; then
            echo -e "${YELLOW}[!] New version available: $LATEST_VERSION (you have $CURRENT_VERSION)${RESET}"
            echo -e "${YELLOW}[*] Would you like to update? (y/n)${RESET}"
            echo -en "${GREEN}➤ ${RESET}"
            read update_choice

            if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
                echo -e "${YELLOW}[*] Downloading latest version...${RESET}"

                # Download the new version
                curl -s "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/catfish.sh" -o "catfish.sh.new"

                if [[ $? -eq 0 ]]; then
                    # Make the new version executable
                    chmod +x "catfish.sh.new"

                    # Create a backup of the old version
                    mv "catfish.sh" "catfish.sh.backup"

                    # Replace with the new version
                    mv "catfish.sh.new" "catfish.sh"

                    echo -e "${GREEN}[✓] Update successful! Restart the script to use the new version.${RESET}"
                    exit 0
                else
                    echo -e "${RED}[!] Update failed. Please try again later.${RESET}"
                fi
            else
                echo -e "${GREEN}[✓] Continuing with current version${RESET}"
            fi
        else
            echo -e "${GREEN}[✓] You have the latest version!${RESET}"
        fi
    else
        echo -e "${YELLOW}[!] Cannot check for updates. curl or grep is missing.${RESET}"
    fi
}

# Function to check URL reputation
check_url_reputation() {
    local url="$1"
    echo -e "\n${BOLD}${CYAN}[*] Would you like to check URL reputation for safety? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read check_choice

    if [[ "$check_choice" == "y" || "$check_choice" == "Y" ]]; then
        echo -e "${YELLOW}[*] Checking URL reputation...${RESET}"

        # Using Google Safe Browsing API (you'd need to get an API key)
        if [[ -n "$SAFE_BROWSING_API_KEY" ]]; then
            local result=$(curl -s -H "Content-Type: application/json" \
                -d "{\"client\":{\"clientId\":\"CatFish\",\"clientVersion\":\"1.0\"},\"threatInfo\":{\"threatTypes\":[\"MALWARE\",\"SOCIAL_ENGINEERING\"],\"platformTypes\":[\"ANY_PLATFORM\"],\"threatEntryTypes\":[\"URL\"],\"threatEntries\":[{\"url\":\"$url\"}]}}" \
                "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$SAFE_BROWSING_API_KEY")

            if [[ "$result" == *"matches"* ]]; then
                echo -e "${RED}[!] Warning: This URL may be flagged as malicious.${RESET}"
            else
                echo -e "${GREEN}[✓] URL appears to be safe.${RESET}"
            fi
        else
            # Fallback to a more basic check using VirusTotal API
            echo -e "${YELLOW}[!] Safe Browsing API key not configured. Using basic check.${RESET}"

            local encoded_url=$(echo "$url" | sed 's/:/\\:/g' | sed 's/\//\\\//g')
            local check_result=$(curl -s "https://www.virustotal.com/ui/search?query=$encoded_url")

            if [[ "$check_result" == *"malicious"* ]]; then
                echo -e "${RED}[!] Warning: URL may be flagged in reputation databases.${RESET}"
            else
                echo -e "${GREEN}[✓] Basic check passed.${RESET}"
            fi
        fi
    fi
}

# Function to test the masked link
test_link() {
    local url="$1"
    echo -e "\n${BOLD}${CYAN}[*] Would you like to test if the masked link works? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read test_choice

    if [[ "$test_choice" == "y" || "$test_choice" == "Y" ]]; then
        echo -e "${YELLOW}[*] Testing link...${RESET}"

        # Make a request to the masked URL and check redirection
        local test_result=$(curl -s -I -L "$url" | grep -i "location")

        if [[ -n "$test_result" ]]; then
            echo -e "${GREEN}[✓] Link tested successfully! Redirects properly.${RESET}"
            echo -e "${YELLOW}Redirection path:${RESET}"
            echo "$test_result"
        else
            echo -e "${RED}[!] Link test failed or no redirection detected.${RESET}"
            echo -e "${YELLOW}[*] It may still work in a browser.${RESET}"
        fi
    fi
}

# Function to show how the URL might appear in different contexts
show_url_preview() {
    local url="$1"
    local domain="${mask_domain#*://}"
    domain="${domain%%/*}"

    echo -e "\n${BOLD}${CYAN}[*] Would you like to see how this URL might appear? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read preview_choice

    if [[ "$preview_choice" == "y" || "$preview_choice" == "Y" ]]; then
        echo -e "\n${BOLD}${CYAN}=== URL Appearance Preview ===${RESET}"

        echo -e "\n${YELLOW}In a browser address bar:${RESET}"
        echo -e "🔒 $domain/..."

        echo -e "\n${YELLOW}In an email client:${RESET}"
        if [[ -n "$bait_words" ]]; then
            echo -e "$domain - $bait_words"
        else
            echo -e "$domain"
        fi

        echo -e "\n${YELLOW}In a messaging app:${RESET}"
        echo -e "$url"

        echo -e "\n${YELLOW}When hovering (desktop):${RESET}"
        echo -e "http://is.gd/$shorter"

        echo -e "\n${RED}[!] Note: Actual appearance may vary depending on the platform${RESET}"
    fi
}

# Function to copy URL to clipboard
copy_to_clipboard() {
    local text="$1"
    echo -e "\n${BOLD}${CYAN}[*] Copy URL to clipboard? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read copy_choice

    if [[ "$copy_choice" == "y" || "$copy_choice" == "Y" ]]; then
        if command -v xclip &> /dev/null; then
            echo -n "$text" | xclip -selection clipboard
            echo -e "${GREEN}[✓] URL copied to clipboard${RESET}"
        elif command -v xsel &> /dev/null; then
            echo -n "$text" | xsel -ib
            echo -e "${GREEN}[✓] URL copied to clipboard${RESET}"
        else
            echo -e "${YELLOW}[!] xclip or xsel not found. Install one of them to enable clipboard functionality.${RESET}"
        fi
    fi
}

# Function to open URL in browser
open_in_browser() {
    local url="$1"
    echo -e "\n${BOLD}${CYAN}[*] Would you like to open this URL in a browser? (y/n)${RESET}"
    echo -e "${RED}    (Only for testing in a controlled environment)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read open_choice

    if [[ "$open_choice" == "y" || "$open_choice" == "Y" ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$url" &> /dev/null
            echo -e "${GREEN}[✓] URL opened in default browser${RESET}"
        elif command -v firefox &> /dev/null; then
            firefox "$url" &> /dev/null
            echo -e "${GREEN}[✓] URL opened in Firefox${RESET}"
        else
            echo -e "${RED}[!] No browser found to open URL${RESET}"
        fi
    fi
}

# Function to display statistics
show_statistics() {
    echo -e "\n${BOLD}${CYAN}[*] Would you like to see usage statistics? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read stats_choice

    if [[ "$stats_choice" == "y" || "$stats_choice" == "Y" ]]; then
        if [[ -f "logs/catfish_history.log" ]]; then
            echo -e "\n${BOLD}${CYAN}=== CatFish Statistics ===${RESET}"

            total_urls=$(wc -l < logs/catfish_history.log)
            echo -e "${YELLOW}Total URLs created:${RESET} $total_urls"

            if [[ "$total_urls" -gt 0 ]]; then
                echo -e "\n${YELLOW}Most recent URLs:${RESET}"
                tail -n 5 logs/catfish_history.log

                echo -e "\n${YELLOW}Most used domains:${RESET}"
                grep -o "Masked: [^ ]*" logs/catfish_history.log | cut -d'@' -f1 | sort | uniq -c | sort -nr | head -5
            fi

            echo -e "\n${GREEN}[✓] Statistics displayed${RESET}"
        else
            echo -e "${YELLOW}[!] No history file found. Stats unavailable.${RESET}"
        fi
    fi
}

# Function to select URL shortening service
select_shortener() {
    echo -e "\n${BOLD}${CYAN}[*] Select URL shortening service:${RESET}"
    echo -e "    1) is.gd (default)"
    echo -e "    2) TinyURL"
    echo -e "    3) Bitly (requires API key)"
    echo -en "${GREEN}➤ ${RESET}"
    read choice

    case $choice in
        2) echo "tinyurl" ;;
        3) echo "bitly" ;;
        *) echo "isgd" ;;
    esac
}

# Function to show and select templates
select_template() {
    echo -e "\n${BOLD}${CYAN}[*] Would you like to use a template? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read use_template

    if [[ "$use_template" == "y" || "$use_template" == "Y" ]]; then
        echo -e "\n${BOLD}${CYAN}[*] Select a template:${RESET}"
        echo -e "    1) Social Media Login"
        echo -e "    2) Banking Portal"
        echo -e "    3) Email Verification"
        echo -e "    4) Contest Winner"
        echo -e "    5) Custom Template"
        echo -en "${GREEN}➤ ${RESET}"
        read template_choice

        case $template_choice in
            1)
                echo "https://facebook.com" # mask_domain
                echo "login-verify-account" # bait_words
                ;;
            2)
                echo "https://bank-secure.com" # mask_domain
                echo "account-security-update" # bait_words
                ;;
            3)
                echo "https://gmail.com" # mask_domain
                echo "verify-email-now" # bait_words
                ;;
            4)
                echo "https://prize-winner.com" # mask_domain
                echo "claim-your-prize" # bait_words
                ;;
            5)
                echo -e "\n${BOLD}${CYAN}[*] Enter custom mask domain:${RESET}"
                echo -en "${GREEN}➤ ${RESET}"
                read custom_mask

                echo -e "\n${BOLD}${CYAN}[*] Enter custom bait words:${RESET}"
                echo -en "${GREEN}➤ ${RESET}"
                read custom_bait

                echo "$custom_mask" # mask_domain
                echo "$custom_bait" # bait_words
                ;;
            *)
                echo "" # No mask domain
                echo "" # No bait words
                ;;
        esac
        return 0
    fi
    echo "" # No mask domain
    echo "" # No bait words
    return 1
}

# Function to add IP logging capability
add_ip_logger() {
    echo -e "\n${BOLD}${CYAN}[*] Would you like to add IP logging functionality? (y/n)${RESET}"
    echo -e "${RED}    (Use responsibly and only with proper authorization)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read add_logger

    if [[ "$add_logger" == "y" || "$add_logger" == "Y" ]]; then
        echo -e "\n${BOLD}${CYAN}[*] Select IP logger service:${RESET}"
        echo -e "    1) Grabify (recommended)"
        echo -e "    2) IPLogger.org"
        echo -e "    3) Custom logging script"
        echo -en "${GREEN}➤ ${RESET}"
        read logger_choice

        case $logger_choice in
            1)
                echo -e "${YELLOW}[*] To use Grabify:${RESET}"
                echo -e "    1. Visit https://grabify.link/"
                echo -e "    2. Enter your shortened URL: $short_url"
                echo -e "    3. Follow instructions to create your tracking link"
                echo -e "    4. Replace your phishing URL with the Grabify link"

                echo -e "\n${BOLD}${CYAN}[*] Enter your Grabify tracking link:${RESET}"
                echo -en "${GREEN}➤ ${RESET}"
                read grabify_url

                if [[ -n "$grabify_url" ]]; then
                    phishing_url="$grabify_url"
                    echo -e "${GREEN}[✓] Using Grabify link for tracking${RESET}"

                    # Re-shorten the URL
                    echo -e "\n${BOLD}${YELLOW}[*] Re-shortening URL with tracking...${RESET}"
                    short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${phishing_url}")
                    shorter=${short_url#https://}
                fi
                ;;
            2)
                echo -e "${YELLOW}[*] To use IPLogger.org:${RESET}"
                echo -e "    1. Visit https://iplogger.org/"
                echo -e "    2. Create a new logger using your shortened URL: $short_url"
                echo -e "    3. Follow instructions to get your tracking link"

                echo -e "\n${BOLD}${CYAN}[*] Enter your IPLogger tracking link:${RESET}"
                echo -en "${GREEN}➤ ${RESET}"
                read iplogger_url

                if [[ -n "$iplogger_url" ]]; then
                    phishing_url="$iplogger_url"
                    echo -e "${GREEN}[✓] Using IPLogger link for tracking${RESET}"

                    # Re-shorten the URL
                    echo -e "\n${BOLD}${YELLOW}[*] Re-shortening URL with tracking...${RESET}"
                    short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${phishing_url}")
                    shorter=${short_url#https://}
                fi
                ;;
            3)
                echo -e "${YELLOW}[*] For custom logging:${RESET}"
                echo -e "    You'll need to set up your own logging server and script"
                echo -e "    This is an advanced option requiring server knowledge"
                ;;
            *)
                echo -e "${YELLOW}[!] No IP logging selected.${RESET}"
                ;;
        esac
    fi
}

# Process command line arguments
GENERATE_QR=false
SAVE_TO_HISTORY=false
phishing_url=""
mask_domain=""
bait_words=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -u|--url)
            phishing_url="$2"
            shift 2
            ;;
        -m|--mask)
            mask_domain="$2"
            shift 2
            ;;
        -w|--words)
            bait_words="$2"
            shift 2
            ;;
        -q|--qr)
            GENERATE_QR=true
            shift
            ;;
        -s|--save)
            SAVE_TO_HISTORY=true
            shift
            ;;
        *)
            echo -e "${RED}[!] Unknown option: $1${RESET}"
            echo -e "${YELLOW}Use -h or --help for usage information${RESET}"
            exit 1
            ;;
    esac
done

echo -e "\n${BOLD}${CYAN}"
echo -e " ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo -e " ┃   ▄▄▄▄▄▄▄ ▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄▄   ┃"
echo -e " ┃  █       █      █ █            █  ┃"
echo -e " ┃  █       █      █ █▄▄▄▄▄▄▄▄▄▄▄▄█  ┃"
echo -e " ┃  █     ▄▄█      █ █            █  ┃"
echo -e " ┃  █    █  █      █ █   ▄▄▄▄▄▄   █  ┃"
echo -e " ┃  █    █▄▄█      █ █  █      █  █  ┃"
echo -e " ┃  █       █      █ █  █      █  █  ┃"
echo -e " ┃  █▄▄▄▄▄▄▄█▄▄▄▄▄▄█ █▄▄█      █▄▄█  ┃"
echo -e " ┃                                   ┃"
echo -e " ┃        😺 𝐂𝐚𝐭𝐅𝐢𝐬𝐡 😺        ┃"
echo -e " ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${RESET}"
echo -e "\n${BOLD}${YELLOW} 🐱 Purr-fect URL Masking Tool 🐱${RESET}"
echo -e "${MAGENTA} For educational purposes only ${RESET}\n"


load_config
check_dependencies
check_for_updates

# Get phishing URL if not provided via command line
if [[ -z "$phishing_url" ]]; then
    echo -e "${BOLD}${CYAN}[*] Enter your phishing URL (with http or https):${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read phishing_url
fi

# Validate URL
if ! validate_url "$phishing_url"; then
    exit 1
fi

check_url_reputation "$phishing_url"

# Show progress
echo -e "\n${BOLD}${YELLOW}[*] Paws at work... Shortening URL...${RESET}"
spinner=('🐱 ' '😺 ' '😸 ' '😹 ')
for i in {1..10}; do
    for spin in "${spinner[@]}"; do
        echo -ne "\r${spin}"
        sleep 0.1
    done
done

# Select URL shortening service
shortener_service=$(select_shortener)

# Shorten URL using selected service
case $shortener_service in
    "tinyurl")
        short_url=$(curl -s "https://tinyurl.com/api-create.php?url=${phishing_url}")
        if [[ -z "$short_url" ]]; then
            echo -e "\r${RED}[!] URL shortening failed with TinyURL. Trying alternative service...${RESET}"
            short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${phishing_url}")
        fi
        ;;
    "bitly")
        echo -e "\n${BOLD}${CYAN}[*] Enter your Bitly API key:${RESET}"
        echo -en "${GREEN}➤ ${RESET}"
        read -s bitly_key
        echo ""
        short_url=$(curl -s -H "Authorization: Bearer ${bitly_key}" \
            -H "Content-Type: application/json" \
            -X POST "https://api-ssl.bitly.com/v4/shorten" \
            -d "{\"long_url\":\"${phishing_url}\"}" | grep -o '"link":"[^"]*' | cut -d'"' -f4)
        if [[ -z "$short_url" ]]; then
            echo -e "${RED}[!] URL shortening failed with Bitly. Trying alternative service...${RESET}"
            short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${phishing_url}")
        fi
        ;;
    *)
        short_url=$(curl -s "https://is.gd/create.php?format=simple&url=${phishing_url}")
        ;;
esac

# Check if shortening was successful
if [[ -z "$short_url" || "$short_url" == *"Error"* ]]; then
    echo -e "\r${RED}[!] All URL shortening attempts failed. Please check your internet connection.${RESET}"
    exit 1
fi

shorter=${short_url#https://}
echo -e "\r${GREEN}[✓] URL shortened successfully!${RESET}"

add_ip_logger

# Check if template should be used
if [[ -z "$mask_domain" || -z "$bait_words" ]]; then
    template_result=($(select_template))
    if [[ -n "${template_result[0]}" ]]; then
        mask_domain="${template_result[0]}"
        bait_words="${template_result[1]}"
    fi
fi

# Get domain to mask if not provided
if [[ -z "$mask_domain" ]]; then
    echo -e "\n${BOLD}${CYAN}[*] Enter a legitimate-looking domain to mask the URL (with http or https):${RESET}"
    echo -e "${CYAN}    Example: https://facebook.com, https://instagram.com${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read mask_domain

    if ! validate_url "$mask_domain"; then
        exit 1
    fi
fi

# Get social engineering words if not provided
if [[ -z "$bait_words" ]]; then
    echo -e "\n${BOLD}${CYAN}[*] Enter some cat-themed bait words:${RESET}"
    echo -e "${CYAN}    Example: cute-kittens, free-cat-toys, adorable-meow-pics${RESET}"
    echo -e "${RED}    (Don't use spaces - use hyphens instead)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read bait_words
fi

# Check if bait words contain spaces
if [[ "$bait_words" =~ " " ]]; then
    echo -e "\n${RED}[!] Invalid format. Spaces detected in bait words.${RESET}"
    echo -e "${YELLOW}[*] Creating URL without custom bait words...${RESET}"
    bait_words=""
fi

# Generate the masked URL
echo -e "\n${BOLD}${YELLOW}[*] The kitty is crafting your masked URL...${RESET}"
for i in {1..10}; do
    for spin in "${spinner[@]}"; do
        echo -ne "\r${spin}"
        sleep 0.1
    done
done

# Final URL
if [[ -z "$bait_words" ]]; then
    final_url="${mask_domain}@${shorter}"
else
    final_url="${mask_domain}-${bait_words}@${shorter}"
fi

test_link "$final_url"
show_url_preview "$final_url"

# Display the result
echo -e "\n\n${BOLD}${CYAN}[✓] Your CatFish URL is ready!${RESET}\n"
echo -e "${BOLD}${GREEN}    ${final_url}${RESET}\n"

copy_to_clipboard "$final_url"

# Generate QR code if requested
if [ "$GENERATE_QR" = true ] || [[ "$GENERATE_QR" != true && "$GENERATE_QR" != false ]]; then
    echo -e "\n${BOLD}${CYAN}[*] Would you like to generate a QR code for this URL? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read qr_choice
    if [[ "$qr_choice" == "y" || "$qr_choice" == "Y" ]]; then
        GENERATE_QR=true
    fi
fi

if [ "$GENERATE_QR" = true ]; then
    if check_qrencode; then
        mkdir -p output
        qr_file="output/catfish_qr_$(date +%s).png"
        qrencode -o "$qr_file" "$final_url"
        echo -e "${GREEN}[✓] QR code saved to ${qr_file}${RESET}"
    fi
fi

# Save to history if requested
if [ "$SAVE_TO_HISTORY" = true ] || [[ "$SAVE_TO_HISTORY" != true && "$SAVE_TO_HISTORY" != false ]]; then
    echo -e "\n${BOLD}${CYAN}[*] Save this URL to history? (y/n)${RESET}"
    echo -en "${GREEN}➤ ${RESET}"
    read save_choice
    if [[ "$save_choice" == "y" || "$save_choice" == "Y" ]]; then
        SAVE_TO_HISTORY=true
    fi
fi

if [ "$SAVE_TO_HISTORY" = true ]; then
    mkdir -p logs
    log_file="logs/catfish_history.log"
    echo "[$(date)] Original: $phishing_url | Masked: $final_url" >> "$log_file"
    echo -e "${GREEN}[✓] URL saved to history log${RESET}"
fi

open_in_browser "$final_url"
show_statistics

echo -e "\n${YELLOW}[!] Remember: Only use this for educational purposes with proper authorization.${RESET}"
echo -e "${CYAN}    Meow! Happy learning! 🐱${RESET}\n"

