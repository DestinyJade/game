#!/bin/bash

# SkyOffice Production Management Script
# Usage: ./manage-production.sh [status|logs|restart|stop|start|monitor]

SERVER_IP="128.199.9.122"
SERVER_USER="root"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo ""
    echo "======================================"
    echo "🎮 SkyOffice Production Manager"
    echo "======================================"
    echo ""
}

case "$1" in
    status)
        print_header
        echo -e "${YELLOW}📊 Checking server status...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 status skyoffice && echo '' && free -h && echo '' && df -h | grep -E '^/dev/'"
        ;;
        
    logs)
        print_header
        echo -e "${YELLOW}📝 Showing recent logs (Ctrl+C to exit)...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 logs skyoffice --lines 50"
        ;;
        
    restart)
        print_header
        echo -e "${YELLOW}🔄 Restarting SkyOffice server...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 restart skyoffice"
        echo -e "${GREEN}✅ Server restarted${NC}"
        ;;
        
    stop)
        print_header
        echo -e "${YELLOW}⏹️  Stopping SkyOffice server...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 stop skyoffice"
        echo -e "${RED}🛑 Server stopped${NC}"
        ;;
        
    start)
        print_header
        echo -e "${YELLOW}▶️  Starting SkyOffice server...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 start skyoffice"
        echo -e "${GREEN}✅ Server started${NC}"
        ;;
        
    monitor)
        print_header
        echo -e "${YELLOW}📈 Opening real-time monitor (Ctrl+C to exit)...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP} "pm2 monit"
        ;;
        
    deploy)
        ./deploy-to-production.sh
        ;;
        
    ssh)
        print_header
        echo -e "${YELLOW}🔐 Connecting to server...${NC}"
        ssh ${SERVER_USER}@${SERVER_IP}
        ;;
        
    health)
        print_header
        echo -e "${YELLOW}🏥 Running health check...${NC}"
        echo ""
        
        # Check if server is reachable
        if ping -c 1 -W 2 ${SERVER_IP} > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Server is reachable${NC}"
        else
            echo -e "${RED}❌ Server is not reachable${NC}"
            exit 1
        fi
        
        # Check if nginx is running
        if ssh ${SERVER_USER}@${SERVER_IP} "systemctl is-active nginx" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Nginx is running${NC}"
        else
            echo -e "${RED}❌ Nginx is not running${NC}"
        fi
        
        # Check if PM2 process is running
        if ssh ${SERVER_USER}@${SERVER_IP} "pm2 list | grep -q skyoffice" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ SkyOffice server is running${NC}"
        else
            echo -e "${RED}❌ SkyOffice server is not running${NC}"
        fi
        
        # Check website availability
        if curl -s -o /dev/null -w "%{http_code}" http://${SERVER_IP}/ | grep -q "200"; then
            echo -e "${GREEN}✅ Website is accessible${NC}"
        else
            echo -e "${RED}❌ Website is not accessible${NC}"
        fi
        
        echo ""
        echo -e "${GREEN}🌐 Access at: http://${SERVER_IP}/${NC}"
        ;;
        
    *)
        print_header
        echo "Usage: $0 {status|logs|restart|stop|start|monitor|deploy|ssh|health}"
        echo ""
        echo "Commands:"
        echo "  status   - Show server status and resources"
        echo "  logs     - Display recent server logs"
        echo "  restart  - Restart the SkyOffice server"
        echo "  stop     - Stop the SkyOffice server"
        echo "  start    - Start the SkyOffice server"
        echo "  monitor  - Open real-time monitoring"
        echo "  deploy   - Deploy latest code to production"
        echo "  ssh      - Connect to production server"
        echo "  health   - Run health check"
        echo ""
        echo "Example:"
        echo "  $0 status"
        echo "  $0 logs"
        echo "  $0 deploy"
        exit 1
        ;;
esac

echo ""