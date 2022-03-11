# arched
## Archlinux installation and configuration script.

### On live installation shell run:
`curl -L https://github.com/eunoiapolis/arched/archive/main.tar.gz --output arched && tar -xvf arched && rm arched && chmod +x ./arched-main/live.sh && ./arched-main/live.sh`

### After chrooting:
`cd ~ && git clone https://github.com/eunoiapolis/arched.git && chmod +x ./arched/chroot.sh && ./arched/chroot.sh`

### After rebooting:
`cd ~ && git clone https://github.com/eunoiapolis/arched.git && chmod +x ./arched/reboot.sh && ./arched/reboot.sh`
