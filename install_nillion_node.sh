
#!/bin/bash

# Sprawdzenie, czy skrypt jest uruchamiany jako root
if [ "$EUID" -ne 0 ]; then
  echo "Proszę uruchomić skrypt jako root (sudo)."
  exit
fi

# Aktualizacja systemu
echo "Aktualizacja systemu..."
apt update && apt upgrade -y

# Instalacja jq
echo "Instalacja jq..."
apt install -y jq

# Instalacja Dockera
echo "Instalacja Dockera..."
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# Sprawdzenie, czy Docker został zainstalowany poprawnie
if ! command -v docker &> /dev/null; then
    echo "Docker nie został zainstalowany prawidłowo."
    exit 1
fi

echo "Docker został zainstalowany pomyślnie."

# Instalacja nilup
echo "Instalacja nilup..."
curl https://nilup.nilogy.xyz/install.sh | bash

# Sprawdzenie instalacji nilup
if ! command -v nilup &> /dev/null; then
    echo "Nilup nie został zainstalowany prawidłowo."
    exit 1
fi

# Instalacja Nillion SDK
echo "Instalacja Nillion SDK..."
nilup install latest
nilup use latest
nilup init

# Krok 4: Pobieranie obrazu weryfikatora
echo "Pobieranie obrazu weryfikatora z Docker Hub..."
docker pull nillion/verifier:v1.0.1

# Krok 5: Uruchomienie węzła Nillion
echo "Uruchamianie węzła Nillion..."
docker run -d --name nillion-verifier -v /path/to/your/data:/var/tmp nillion/verifier:v1.0.1

echo "Węzeł Nillion został uruchomiony pomyślnie!"
