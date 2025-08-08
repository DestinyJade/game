#!/bin/bash

# SkyOffice Production Deployment Script
# Usage: ./deploy-to-production.sh

set -e  # Exit on error

echo "======================================"
echo "🚀 SkyOffice Production Deployment"
echo "======================================"
echo ""

# Configuration
SERVER_IP="128.199.9.122"
SERVER_USER="root"
REMOTE_PATH="/root/game"
BUILD_MEMORY="768"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if we can connect to server
print_info "Testing server connection..."
if ssh -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_IP} "echo 'Connection successful'" > /dev/null 2>&1; then
    print_status "Server connection established"
else
    print_error "Cannot connect to server at ${SERVER_IP}"
    exit 1
fi

# Deploy to production
print_info "Starting deployment to ${SERVER_IP}..."

# Execute deployment on remote server
ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
set -e

echo "📥 Pulling latest code from GitHub..."
cd /root/game
git pull origin main

echo "📦 Installing server dependencies..."
cd SkyOffice
npm install

echo "📦 Installing client dependencies..."
cd client
npm install --legacy-peer-deps

echo "🔨 Building client for production..."
NODE_OPTIONS='--max-old-space-size=768' npm run build

echo "📂 Deploying built files to web directory..."
cp -r dist/* /var/www/skyoffice/
chown -R www-data:www-data /var/www/skyoffice

echo "🔄 Restarting SkyOffice server..."
pm2 restart skyoffice

echo "📊 Checking server status..."
pm2 status skyoffice

echo "✅ Deployment complete!"
ENDSSH

if [ $? -eq 0 ]; then
    print_status "Deployment completed successfully!"
    echo ""
    echo "======================================"
    echo "📱 Access your SkyOffice at:"
    echo "   http://${SERVER_IP}/"
    echo "======================================"
    echo ""
    print_info "Server Management Commands:"
    echo "  View logs:    ssh ${SERVER_USER}@${SERVER_IP} 'pm2 logs skyoffice'"
    echo "  Check status: ssh ${SERVER_USER}@${SERVER_IP} 'pm2 status'"
    echo "  Restart:      ssh ${SERVER_USER}@${SERVER_IP} 'pm2 restart skyoffice'"
else
    print_error "Deployment failed! Check the logs above for errors."
    exit 1
fi