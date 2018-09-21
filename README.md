# linux-server-salt-hard

### Description
This currently sets up an Arch Linux installation

### Prerequisites
- Working internet connection

### Space requirement
- System drive
  - Current salt states download/install around 10 GiB of data

### Instructions
#### Get the setup files
#### With Git
- Update package database and install git : `pacman -Sy git`
- Get the files : `git clone https://github.com/darrenldl/linux-server-salt-hard.git`

#### Without Git
- `wget https://github.com/darrenldl/linux-server-salt-hard/archive/master.tar.gz -O - | tar xz`

#### Start the setup
- `cd linux-server-salt-hard/scripts; ./setup.sh`

### License
Unlicense - https://unlicense.org/
