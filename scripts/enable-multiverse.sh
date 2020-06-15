echo "# deb http://snapshot.debian.org/archive/debian/20200514T145000Z buster main" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
echo "# deb http://snapshot.debian.org/archive/debian-security/20200514T145000Z buster/updates main" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
echo "# deb http://snapshot.debian.org/archive/debian/20200514T145000Z buster-updates main" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list
apt-get update
apt-get install -y rar unrar zip unzip
gem install cbr2cbz