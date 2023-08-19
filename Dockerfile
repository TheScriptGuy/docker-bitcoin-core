FROM alpine:latest as build

#
# First get all the packages for
# the compile
#
RUN apk update && apk add git \
                          make \
                          file \
                          autoconf \
                          automake \
                          build-base \
                          libtool \
                          db-c++ \
                          db-dev \
                          boost-system \
                          boost-program_options \
                          boost-filesystem \
                          boost-dev \
                          libressl-dev \
                          libevent-dev

#
# Pull source code from bitcoin GitHub
#
RUN git clone https://github.com/bitcoin/bitcoin --branch master --single-branch

#
# Install the required packages to compile the bitcoin binaries.
#
RUN (cd bitcoin  && ./autogen.sh && \
                      ./configure --disable-tests \
                      --disable-bench --disable-static  \
                      --without-gui --disable-zmq \
                      --with-incompatible-bdb \
                      CFLAGS='-w' CXXFLAGS='-w' && \
                      make -j 16 && \
                      strip src/bitcoind && \
                      strip src/bitcoin-cli && \
                      strip src/bitcoin-tx && \
                      make install )

FROM alpine:latest

#
# Copy the binaries from the build to our new container
#
COPY --from=build /usr/local/bin/bitcoind /usr/local/bin
COPY --from=build /usr/local/bin/bitcoin-cli /usr/local/bin

#
# Install all dependencies
#
RUN apk update && apk add boost boost-filesystem \
            boost-program_options \
            boost-system boost-thread busybox db-c++ \
            libevent libgcc libressl3.6-libcrypto \
            libstdc++ musl tor vim shadow

#
# Copy entrypoint.sh script, set required permissions for entrypoint.sh
# Create the bitcoin user (uid 100000) and bitcoin group (gid 100000)
#
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown root.root /entrypoint.sh
RUN /usr/sbin/groupadd -g 100000 bitcoin && /usr/sbin/useradd -u 100000 -g 100000 bitcoin

# Expose the bitcoin-core TCP port 8333
EXPOSE 8333/tcp

# Set the user to bitcoin
USER bitcoin

#
# Start the bitcoin server
#
ENTRYPOINT ["/entrypoint.sh"]
