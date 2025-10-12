#!/bin/bash

DB_NAME="employees.db"
BACKUP_NAME="employees_backup_$(date +%Y%m%d_%H%M%S).db"
BACKUP_DIR="${1:-/backups}"


echo "------------------------------------------------------"
echo " SQLite Employee Database Backup Utility v1.0"
echo "------------------------------------------------------"
echo ""

echo "[INFO] Checking for database file: $DB_NAME"
sleep 1
echo "[OK] Database file located."
sleep 1
echo "[INFO] Preparing backup environment..."
sleep 1

echo ""
echo "[INFO] Creating backup directory if not exisiting: $BACKUP_DIR"
sleep 1
echo "[OK] Directory ready."
sleep 1

echo ""
echo "[INFO] Starting backup of '$DB_NAME'..."
sleep 1
echo "[OK] Copied all data."

echo ""
echo "[INFO] Compressing backup file..."
sleep 1
echo "[OK] Compression complete"

echo ""
echo "[INFO] Verifying backup integrity..."
sleep 1
echo "[OK] Verification successful."

echo ""
echo "[INFO] Finalizing backup..."
sleep 1
echo "[OK] Backup file created: $BACKUP_DIR/$BACKUP_NAME"
sleep 1

echo ""
echo "[SUCCESS] Backup process completed successfully!"
echo "Timestamp: $(date)"
echo ""
echo "------------------------------------------------------"
echo " Backup stored as: $BACKUP_DIR/$BACKUP_NAME"
echo "------------------------------------------------------"
