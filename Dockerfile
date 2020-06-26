FROM alpine:latest
RUN apk add --no-cache libc6-compat cmake ninja git gcc g++ yasm bash curl make linux-headers
ENV VCPKG_FORCE_SYSTEM_BINARIES 1
RUN git clone https://github.com/microsoft/vcpkg.git && \
  cd vcpkg && \
  chmod 777 bootstrap-vcpkg.sh && \
  ./bootstrap-vcpkg.sh --useSystemBinaries --disableMetrics && \
  rm -rf /vcpkg/toolsrc/build.rel && \
  rm -rf /vcpkg/.git && \
  mkdir -p downloads
COPY darknet-cache /vcpkg/downloads/
RUN cd vcpkg && \
  ./vcpkg install darknet[opencv-base,weights,weights-train] --triplet x64-linux --clean-after-build && \
  rm -rf ports && \
  rm -f vcpkg
