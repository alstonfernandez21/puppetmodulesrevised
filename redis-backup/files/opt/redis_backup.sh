#!/bin/sh
REDIS_SOURCE=/data/redis/dump.rdb
BACKUP_DIR=/data/backup/redis

BACKUP_PREFIX="redis.dump.rdb"
DAY=`date '+%a_%m_%d_%Y_%H%M%S'`
REDIS_DEST="$BACKUP_DIR/$BACKUP_PREFIX.$DAY"

cp $REDIS_SOURCE $REDIS_DEST

