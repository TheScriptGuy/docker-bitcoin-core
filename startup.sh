#!/bin/sh
BINDIR="/bin"
BITCOIN_BINDIR="/usr/local/bin/"
BITCOIN_DATADIR="/data"

RPCUSER=mybitcoinuser
RPCPASSWORD=myb1tc01np455w0rd

# Function to gracefully stop bitcoind
stop_bitcoind() {
  echo "Stopping bitcoind..."
  $BITCOIN_BINDIR/bitcoin-cli -rpcuser=$RPCUSER -rpcpassword=$RPCPASSWORD stop
}

# Function to handle the SIGTERM signal
handle_sigterm() {
  echo "Received SIGTERM signal. Performing graceful shutdown..."
  stop_bitcoind
  exit 0
}

# Trap SIGTERM signal and invoke the handler

# Start bitcoind
$BITCOIN_BINDIR/bitcoind -conf=/data/bitcoin.conf -noproxy -daemon

BITCOIN_PID=`$BINDIR/cat $BITCOIN_DATADIR/bitcoind.pid`

# Wait for the script to be terminated
wait "$BITCOIN_PID"

