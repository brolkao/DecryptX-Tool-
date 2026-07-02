#!/data/data/com.termux/files/usr/bin/bash
# DecryptX-Tool
# Made by: brolkao


clear
echo "=================================================="
echo "          DECRYPTX - TOOL"
echo "         Made by: brolkao | GitHub"
echo "=================================================="
echo ""

# ----------------------
# CLEAN OUTPUT
# ----------------------
clean() {
    # Keep ONLY letters, numbers, spaces, and normal symbols
    echo "$1" | tr -cd '[:alnum:] !@#$%^&*()_+-=[]{}|;:",.<>?`~'
}

# ----------------------
# Decrypt Functions
# ----------------------
try_des3() {
    openssl enc -d -des3 -a -k "password" 2>/dev/null <<< "$1"
}

try_aes256() {
    openssl enc -d -aes-256-cbc -a -k "password" 2>/dev/null <<< "$1"
}

try_des() {
    openssl enc -d -des -a -k "password" 2>/dev/null <<< "$1"
}

try_base64() {
    base64 -d 2>/dev/null <<< "$1"
}

try_hex() {
    xxd -r -p 2>/dev/null <<< "$1"
}

# ----------------------
# Save Result
# ----------------------
save() {
    echo -e "Type: $1\nDecrypted: $2" > decrypted.txt
    echo "✅ Saved to: decrypted.txt"
}

# ----------------------
# Decrypt Text
# ----------------------
decrypt_text() {
    read -p "🔐 Put your encrypted word: " inp
    [ -z "$inp" ] && { echo "❌ Empty input!"; return; }

    # Try DES3 first
    out=$(clean "$(try_des3 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: DES3"; echo "📄 Result: $out"; save "DES3" "$out"; return; }

    # Then AES-256-CBC
    out=$(clean "$(try_aes256 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: AES-256-CBC"; echo "📄 Result: $out"; save "AES-256-CBC" "$out"; return; }

    # Then others
    out=$(clean "$(try_des "$inp")")
    [ -n "$out" ] && { echo "✅ Type: DES"; echo "📄 Result: $out"; save "DES" "$out"; return; }

    out=$(clean "$(try_base64 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: Base64"; echo "📄 Result: $out"; save "Base64" "$out"; return; }

    out=$(clean "$(try_hex "$inp")")
    [ -n "$out" ] && { echo "✅ Type: Hex"; echo "📄 Result: $out"; save "Hex" "$out"; return; }

    echo "❌ Failed. Check password/format."
}

# ----------------------
# Decrypt File
# ----------------------
decrypt_file() {
    read -p "📂 Put your file path: " path
    [ ! -f "$path" ] && { echo "❌ File not found!"; return; }
    inp=$(tr -d '\n' < "$path")

    out=$(clean "$(try_des3 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: DES3"; echo "📄 Result: $out"; save "DES3" "$out"; return; }

    out=$(clean "$(try_aes256 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: AES-256-CBC"; echo "📄 Result: $out"; save "AES-256-CBC" "$out"; return; }

    out=$(clean "$(try_des "$inp")")
    [ -n "$out" ] && { echo "✅ Type: DES"; echo "📄 Result: $out"; save "DES" "$out"; return; }

    out=$(clean "$(try_base64 "$inp")")
    [ -n "$out" ] && { echo "✅ Type: Base64"; echo "📄 Result: $out"; save "Base64" "$out"; return; }

    out=$(clean "$(try_hex "$inp")")
    [ -n "$out" ] && { echo "✅ Type: Hex"; echo "📄 Result: $out"; save "Hex" "$out"; return; }

    echo "❌ Failed. Check password/format."
}

# ----------------------
# Main Menu
# ----------------------
while true; do
    echo ""
    echo "[ MENU ]"
    echo "1. Decrypt letters/text"
    echo "2. Decrypt files"
    echo "3. Exit"
    read -p "Enter choice: " opt
    case $opt in
        1) decrypt_text ;;
        2) decrypt_file ;;
        3) echo "👋 Exiting..."; exit 0 ;;
        *) echo "❌ Invalid choice!" ;;
    esac
done
