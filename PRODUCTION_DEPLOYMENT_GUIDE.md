# 🚀 PRODUCTION DEPLOYMENT GUIDE - SkyOffice Virtual Office

## 📋 Quick Deployment Commands

### Deploy Latest Version (One Command)
```bash
ssh root@128.199.9.122 "cd /root/game && git pull && cd SkyOffice && npm install && cd client && npm install --legacy-peer-deps && NODE_OPTIONS='--max-old-space-size=768' npm run build && cp -r dist/* /var/www/skyoffice/ && pm2 restart skyoffice"
```

## 🏗️ Server Infrastructure

### DigitalOcean Droplet Details
- **Name**: inner-shift
- **IP**: 128.199.9.122
- **Specs**: 1GB RAM / 1 vCPU / 35GB SSD
- **OS**: Ubuntu 25.04 x64
- **Monthly Cost**: $8/month
- **Capacity**: 3-5 concurrent users

### Installed Software
| Software | Version | Purpose |
|----------|---------|---------|
| Node.js | v18.20.8 | JavaScript runtime |
| npm | 10.8.2 | Package manager |
| nginx | 1.26.3 | Web server/reverse proxy |
| PM2 | Latest | Process manager |
| Docker | 28.3.3 | Container runtime (for LiveKit) |
| Git | 2.48.1 | Version control |

## 📁 File Locations

### Application Files
```
/root/game/                     # Main repository clone
├── SkyOffice/                  # SkyOffice application
│   ├── server/                 # Backend server (Colyseus)
│   └── client/                 # Frontend React app
│       └── dist/               # Built production files
└── /var/www/skyoffice/         # Nginx serves from here
```

### Configuration Files
```
/etc/nginx/sites-available/skyoffice  # Nginx configuration
/root/game/SkyOffice/client/.env.production  # Client environment
```

## 🔄 Deployment Process

### Step 1: Connect to Server
```bash
ssh root@128.199.9.122
```

### Step 2: Pull Latest Code
```bash
cd /root/game
git pull origin main
```

### Step 3: Install Dependencies (if package.json changed)
```bash
cd /root/game/SkyOffice
npm install

cd client
npm install --legacy-peer-deps
```

### Step 4: Build Client
```bash
cd /root/game/SkyOffice/client
NODE_OPTIONS='--max-old-space-size=768' npm run build
```

### Step 5: Deploy Built Files
```bash
cp -r /root/game/SkyOffice/client/dist/* /var/www/skyoffice/
chown -R www-data:www-data /var/www/skyoffice
```

### Step 6: Restart Server
```bash
pm2 restart skyoffice
```

## 🔧 Server Management

### PM2 Process Manager Commands
```bash
# Check status
pm2 status

# View logs
pm2 logs skyoffice

# Restart server
pm2 restart skyoffice

# Stop server
pm2 stop skyoffice

# Start server
pm2 start skyoffice

# Monitor resources
pm2 monit
```

### Nginx Commands
```bash
# Test configuration
nginx -t

# Reload configuration
systemctl reload nginx

# Restart nginx
systemctl restart nginx

# Check status
systemctl status nginx
```

### System Monitoring
```bash
# Check memory usage
free -h

# Monitor processes
htop

# Check disk space
df -h

# View system logs
journalctl -xe
```

## 🛠️ Troubleshooting

### Server Not Starting
```bash
# Check if port 2567 is in use
lsof -i :2567

# Kill process using port
kill <PID>

# Restart PM2
pm2 restart skyoffice
```

### Client Not Loading
```bash
# Check nginx error logs
tail -f /var/log/nginx/error.log

# Verify file permissions
ls -la /var/www/skyoffice/

# Fix permissions if needed
chown -R www-data:www-data /var/www/skyoffice
```

### Out of Memory
```bash
# Check swap usage
free -h

# If swap not configured
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

## 🔐 Security Checklist

### Current Status
- [ ] SSL Certificate (Not configured - use Let's Encrypt)
- [x] Firewall (Basic - can be enhanced)
- [x] Swap file configured (1GB)
- [ ] Non-root user (Currently using root)
- [ ] Fail2ban (Not installed)

### Future Security Steps
```bash
# Install SSL with Let's Encrypt
apt install certbot python3-certbot-nginx
certbot --nginx -d yourdomain.com

# Configure firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

# Create deployment user
adduser deploy
usermod -aG sudo deploy
```

## 📊 Performance Optimization

### Current Configuration
- **RAM**: 960MB + 1GB Swap = 1.96GB Total
- **Node Memory**: Limited to 768MB for builds
- **PM2**: Single instance running

### Scaling Options
1. **Immediate (0-5 users)**: Current setup is sufficient
2. **Small (5-10 users)**: Upgrade to 2GB RAM ($16/month)
3. **Medium (10-20 users)**: Upgrade to 4GB RAM ($32/month)
4. **Large (20+ users)**: Multiple servers with load balancer

### Performance Commands
```bash
# Monitor PM2 metrics
pm2 monit

# Check nginx connections
nginx -T 2>&1 | grep -E "(worker_connections|worker_processes)"

# System performance
vmstat 1 5
```

## 🚨 Emergency Procedures

### Full System Restart
```bash
ssh root@128.199.9.122
pm2 kill
systemctl restart nginx
cd /root/game/SkyOffice/server
pm2 start npm --name skyoffice -- start
```

### Rollback Deployment
```bash
cd /root/game
git log --oneline -5  # Find previous commit
git checkout <commit-hash>
# Follow deployment steps
```

### Backup Current State
```bash
# Backup application
tar -czf skyoffice-backup-$(date +%Y%m%d).tar.gz /root/game/SkyOffice

# Backup nginx config
cp /etc/nginx/sites-available/skyoffice /root/skyoffice-nginx-backup
```

## 📝 Environment Variables

### Production Client (.env.production)
```
VITE_SERVER_URL=ws://128.199.9.122/ws
```

### Server Environment (if needed)
```bash
# Create .env in server directory
cd /root/game/SkyOffice/server
cat > .env << EOF
NODE_ENV=production
PORT=2567
EOF
```

## 🔄 Automated Deployment Script

Save this as `/root/deploy.sh`:
```bash
#!/bin/bash
echo "🚀 Starting SkyOffice Deployment..."

# Pull latest code
cd /root/game
echo "📥 Pulling latest code..."
git pull origin main

# Install dependencies
cd SkyOffice
echo "📦 Installing server dependencies..."
npm install

cd client
echo "📦 Installing client dependencies..."
npm install --legacy-peer-deps

# Build client
echo "🔨 Building client..."
NODE_OPTIONS='--max-old-space-size=768' npm run build

# Deploy files
echo "📂 Deploying files..."
cp -r dist/* /var/www/skyoffice/
chown -R www-data:www-data /var/www/skyoffice

# Restart server
echo "🔄 Restarting server..."
pm2 restart skyoffice

echo "✅ Deployment complete!"
echo "🌐 Access at: http://128.199.9.122/"
```

Make it executable:
```bash
chmod +x /root/deploy.sh
```

Run deployment:
```bash
/root/deploy.sh
```

## 📱 Testing Deployment

### Single User Test
1. Visit http://128.199.9.122/
2. Enter username
3. Create room
4. Test WASD movement
5. Check console for errors (F12)

### Multi-User Test
1. Open multiple browser tabs
2. Join same room code
3. Verify all users visible
4. Test proximity chat
5. Monitor server resources: `ssh root@128.199.9.122 "pm2 monit"`

## 📞 Support Information

### Server Access
- **SSH**: `ssh root@128.199.9.122`
- **Web**: http://128.199.9.122/

### Log Locations
- **PM2 Logs**: `pm2 logs skyoffice`
- **Nginx Access**: `/var/log/nginx/access.log`
- **Nginx Errors**: `/var/log/nginx/error.log`
- **System Logs**: `journalctl -xe`

### Quick Health Check
```bash
ssh root@128.199.9.122 "pm2 status && free -h && df -h && systemctl status nginx"
```

---
*Last Updated: August 8, 2025*
*Platform Status: PRODUCTION READY*
*Current Version: Live at http://128.199.9.122/*