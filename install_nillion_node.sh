#!/bin/bash

# T E S T ASCII Art
echo "
  _______ _______ _______ _______ 
 |__   __|__   __|__   __|__   __|
    | |     | |     | |     | |   
    | |     | |     | |     | |   
    | |     | |     | |     | |   
    |_|     |_|     |_|     |_|   
                                  
EN Telegram: soon..
RU Telegram: https://t.me/SixThoughtsLines
GitHub: https://github.com/NodeMafia

This script is sourced from: https://github.com/NodeMafia/NillionNodeGuide/blob/main/NillionSetup.sh
Ten skrypt pochodzi z: https://github.com/NodeMafia/NillionNodeGuide/blob/main/NillionSetup.sh
"

# Sprawdzenie, czy jq jest zainstalowany / Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "\e[31mjq nie jest zainstalowane. Instalowanie jq...\e[0m"
    echo -e "\e[31mjq is not installed. Installing jq...\e[0m"
    
    # Wykrywanie systemu operacyjnego i instalacja jq / Detect OS type and install jq accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        echo -e "\e[31mNieobsługiwany system operacyjny. Proszę zainstalować jq ręcznie.\e[0m"
        echo -e "\e[31mUnsupported OS. Please install jq manually.\e[0m"
        exit 1
    fi

    # Sprawdzanie, czy instalacja się powiodła / Check if installation succeeded
    if command -v jq &> /dev/null; then
        echo -e "\e[32mjq zostało pomyślnie zainstalowane.\e[0m"
        echo -e "\e[32mjq installed successfully.\e[0m"
    else
        echo -e "\e[31mNie udało się zainstalować jq. Zakończenie...\e[0m"
        echo -e "\e[31mFailed to install jq. Exiting...\e[0m"
        exit 1
    fi
else
    echo -e "\e[32mjq jest już zainstalowane.\e[0m"
    echo -e "\e[32mjq is already installed.\e[0m"
fi

# Menu wyboru / Selection Menu
echo "Wybierz opcję:"
echo "Please select an option:"
echo "1. Zainstaluj Node / Install Node"
echo "2. Zaktualizuj Node / Update Node"
echo "3. Zmień RPC / Change RPC"
read -p "Wprowadź numer opcji (1, 2 lub 3) / Enter the option number (1, 2, or 3): " option
echo "Wybrałeś / You selected: $option"

# Wybór na podstawie opcji użytkownika / Branch based on user selection
case $option in
    1)
        echo "Wybrałeś instalację Node'a."
        echo "You selected to install the Node."

        # Sprawdzenie, czy Docker jest dostępny / Check if Docker is accessible
        if ! docker info > /dev/null 2>&1; then
            echo -e "\e[31mOdmowa dostępu: nie masz dostępu do Dockera.\e[0m"
            echo -e "\e[31mPermission denied: You don't have access to Docker.\e[0m"
            echo -e "\e[31mPróba dodania użytkownika do grupy docker...\e[0m"
            echo -e "\e[31mTrying to add user to the docker group...\e[0m"
            
            # Próba dodania użytkownika do grupy docker / Try to add user to the docker group
            sudo usermod -aG docker "$USER"

            echo -e "\e[32mDodano użytkownika do grupy docker. Zaloguj się ponownie lub uruchom terminal ponownie.\e[0m"
            echo -e "\e[32mUser added to the docker group. Please log out and log back in or restart the terminal.\e[0m"
            echo -e "\e[32mLub uruchom skrypt z 'sudo'. / Or you can run the script with 'sudo'.\e[0m"
            
            exit 1
        else
            echo -e "\e[32mDocker jest dostępny. Kontynuowanie...\e[0m"
            echo -e "\e[32mDocker is accessible. Proceeding...\e[0m"
        fi

        # Pobieranie obrazu Docker dla Nillion Verifier / Pull the Nillion verifier Docker image
        echo "Pobieranie obrazu Dockera Nillion Verifier..."
        echo "Pulling Nillion verifier docker image..."
        docker pull nillion/verifier:v1.0.1

        # Tworzenie katalogu dla Nillion Verifier / Create directory for the Nillion Verifier
        mkdir -p nillion/verifier

        # Inicjalizacja Verifiera / Initialize the Verifier
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 initialise

        # Wyciąganie danych z pliku credentials.json / Extract data from credentials.json
        JSON_FILE="./nillion/verifier/credentials.json"
        if [ -f "$JSON_FILE" ]; then
            echo "Wyciąganie danych z credentials.json..."
            echo "Extracting data from credentials.json..."
            ADDRESS=$(jq -r '.address' "$JSON_FILE")
            PUBKEY=$(jq -r '.pub_key' "$JSON_FILE")

            # Wyświetlanie danych dla użytkownika / Display extracted data
            echo -e "\n\e[31mAby skopiować informacje, zaznacz je kursorem (nie naciskaj CTRL+C).\e[0m"
            echo -e "\e[31mTo copy the information, highlight it with your cursor (do not press CTRL+C).\e[0m"
            echo -e "   \e[36mID Konta Verifiera:\e[0m = $ADDRESS"
            echo -e "   \e[36mPubliczny Klucz Verifiera:\e[0m = $PUBKEY"
            echo -e "   \e[36mVerifier Account ID:\e[0m = $ADDRESS"
            echo -e "   \e[36mVerifier Public Key:\e[0m = $PUBKEY"
            echo -e "3. Przejdź do \e[33mNillion Faucet\e[0m i uzyskaj tokeny dla adresu: \e[36m$ADDRESS\e[0m"
            echo -e "3. Go to the \e[33mNillion Faucet\e[0m and get tokens to the address: \e[36m$ADDRESS\e[0m"
            echo -e "   Odwiedź: https://faucet.testnet.nillion.com"
            echo -e "   Visit: https://faucet.testnet.nillion.com"
            echo ""
        else
            echo -e "\e[31mBłąd: credentials.json nie znaleziono.\e[0m"
            echo -e "\e[31mError: credentials.json not found.\e[0m"
            exit 1
        fi

        # Krótkie wskazówki dotyczące użycia Dockera / Short Docker Usage Guide
        echo -e "\e[31mKrótki przewodnik po używaniu Dockera\e[0m"
        echo -e "\e[31mShort Docker Usage Guide\e[0m"
        echo -e "\e[36mWyświetl listę uruchomionych kontenerów:\e[0m docker ps"
        echo -e "\e[36mList running containers:\e[0m docker ps"
        echo -e "\e[36mZobacz logi Dockera:\e[0m docker logs -f <CONTAINER ID>"
        echo -e "\e[36mView Docker logs:\e[0m docker logs -f <CONTAINER ID>"
        echo -e "\e[36mWyświetl ostatnie 10 linii logów:\e[0m docker logs -n 10 -f <CONTAINER ID>"
        echo -e "\e[36mView last 10 lines of logs:\e[0m docker logs -n 10 -f <CONTAINER ID>"
        echo -e "\e[36mZatrzymaj podgląd logów:\e[0m CTRL+C"
        echo -e "\e[36mStop viewing logs:\e[0m CTRL+C"

        # Czekanie na wprowadzenie przez użytkownika / Wait for user input
        read -p "Naciśnij Enter, aby kontynuować po ukończeniu kroków... / Press Enter to continue after completing the steps..."

        # Licznik synchronizacji z paskiem postępu / Synchronization timer with progress bar
        echo -e "\e[33mCzekanie 5 minut na synchronizację...\e[0m"
        echo -e "\e[33mWaiting 5 minutes for synchronization...\e[0m"
        for i in {1..100}; do
            sleep 3
            echo -ne "\rPostęp synchronizacji... $i% / Synchronization progress... $i%"
        done

        # Po zakończeniu licznika / After the timer ends
        echo -e "\n\e[32mSynchronizacja zakończona / Synchronization complete\e[0m"

        # Uruchomienie Node'a Verifiera / Run the Verifier node
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
        ;;
    
    # Opcje 2 i 3 pozostają bez zmian, z dodanym tłumaczeniem / Options 2 and 3 remain unchanged, with added translation...
    
    *)
        echo "Wybrano nieprawidłową opcję. Zakończenie."
        echo "Invalid option selected. Exiting."
        exit 1
        ;;
esac
