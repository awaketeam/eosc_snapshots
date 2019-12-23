#!/bin/sh
cd /opt/eosio/bin

DEFAULT_ROOT_PATH="/eosforce"

DEFAULT_CONFIG_DIR="$DEFAULT_ROOT_PATH/config/"
DEFAULT_DATA_DIR="$DEFAULT_ROOT_PATH/data/"

while :; do
    case $1 in
        --config-dir=?*)
            CONFIG_DIR=${1#*=}
            ;;
        *)
            break
    esac
    shift
done

if [ ! "$CONFIG_DIR" ]; then
    CONFIG_DIR=$DEFAULT_CONFIG_DIR
fi

CONFIG_DIR_PARAMS="--config-dir=$CONFIG_DIR"

mkdir -p $CONFIG_DIR
mkdir -p $DEFAULT_DATA_DIR

cp /genesis.json $CONFIG_DIR/
cp /activeacc.json $CONFIG_DIR/

cp /contracts/*.wasm $CONFIG_DIR/
cp /contracts/*.abi $CONFIG_DIR/

if [ -f "$CONFIG_DIR/config.ini" ]; then
    echo "no need copy config.ini"
  else
    echo "copy a default config to config path"
    cp /config.ini $CONFIG_DIR/
fi


prog_exit()
{
    ps -ef | grep nodeos | grep -v grep | awk '{print $2}' | xargs kill -15
}
trap "prog_exit" 15

exec /opt/eosio/bin/nodeos $CONFIG_DIR_PARAMS --data-dir $DEFAULT_DATA_DIR --snapshot=/eosforce/snapshot.bin  $@
