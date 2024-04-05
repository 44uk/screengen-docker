# syntax=docker/dockerfile:1
FROM fedora:40 AS builder

ARG VERSION=""

WORKDIR /workspace

RUN dnf update -y \
  && dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  && dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  && dnf install -y git make qt5-qtbase qt5-qtbase-devel ffmpeg ffmpeg-devel

RUN git clone https://github.com/OlegKochkin/screengen.git \
  && cd screengen \
  ; if [ "$VERSION" = "" ]; then \
    VERSION=$(git describe --tags `git rev-list --tags --max-count=1`) \
  ; fi \
  ; git checkout ${VERSION} \
  && qmake-qt5 && make -s && make install

FROM fedora:40

RUN dnf update -y \
  && dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  && dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  && dnf install -y qt5-qtbase qt5-qtbase-gui ffmpeg \
  && dnf clean all

COPY --from=builder /usr/bin/screengen /usr/local/bin/screengen

WORKDIR /output

ARG UID=10001
RUN useradd \
  --no-create-home \
  --uid "${UID}" \
  --user-group \
  --shell /sbin/nologin \
  --comment "Application User" \
  appuser
USER appuser

ENTRYPOINT [ "screengen" ]
