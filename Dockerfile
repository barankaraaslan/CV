FROM archlinux

RUN pacman -Syu --noconfirm
RUN pacman -Syu --noconfirm base-devel git

COPY install.sh .
RUN bash install.sh