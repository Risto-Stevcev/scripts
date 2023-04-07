# Replace some.file with the file you want to serve

SOME_FILE=$1
#CERT=$2
#CAFILE=$3
PORT=${2:-8080}

echo "Serving $SOME_FILE on port $PORT..."
{ printf 'HTTP/1.0 200 OK\r\nContent-Length: %d\r\n\r\n' "$(wc -c < $SOME_FILE)"; \
  cat "$SOME_FILE"; \
} | nc -l "$PORT"
#socat -t 5 - openssl-listen:0.0.0.0:$PORT,openssl-commonname=socatssl,cert=$CERT,cafile=$CAFILE  #
