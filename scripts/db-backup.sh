#!/bin/bash

# Script para backup de la base de datos
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql"

mkdir -p $BACKUP_DIR

echo "💾 Creando backup de la base de datos..."
docker-compose exec postgres pg_dump -U admin hoteldb > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Backup creado: $BACKUP_FILE"
else
    echo "Error creando backup"
    exit 1
fi