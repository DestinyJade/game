# Virtual Office Body Doubling Platform - Setup Guide

## Project Overview
A virtual office platform for body doubling/remote coworking sessions with enhanced spatial audio and focus features.

## Directory Structure
```
Inner Shift/
├── SkyOffice/           # Main platform (Phaser + React + Colyseus)
├── livekit/             # LiveKit server for spatial audio
├── livekit-react/       # LiveKit React SDK components
├── spatial-audio/       # Spatial audio example reference
├── Entities/            # Sprite assets - characters
├── Environment/         # Sprite assets - environment tiles
├── Icons/              # Sprite assets - UI icons
└── Weapons/            # Sprite assets - items/weapons
```

## Installed Repositories

### 1. SkyOffice (Primary Base)
- **Repository**: https://github.com/kevinshen56714/SkyOffice
- **License**: MIT
- **Features**: 2D office environment, proximity chat, screen sharing, multiplayer state
- **Tech Stack**: Phaser3, React, Redux, Colyseus, PeerJS
- **Status**: ✅ Cloned and dependencies installed

### 2. LiveKit Server
- **Repository**: https://github.com/livekit/livekit
- **License**: Apache 2.0
- **Purpose**: Self-hosted spatial audio infrastructure
- **Status**: ✅ Cloned

### 3. LiveKit React SDK
- **Repository**: https://github.com/livekit/livekit-react
- **Purpose**: Frontend audio/video components
- **Status**: ✅ Cloned

### 4. LiveKit Spatial Audio Example
- **Repository**: https://github.com/livekit-examples/spatial-audio
- **Purpose**: Reference implementation for spatial audio
- **Status**: ✅ Cloned

## Development Setup

### Prerequisites
- Node.js (v16+ recommended)
- npm or yarn
- Git

### Installation Steps Completed
1. ✅ Cloned all required GitHub repositories
2. ✅ Installed SkyOffice root dependencies
3. ✅ Installed SkyOffice client dependencies (with --legacy-peer-deps)
4. ✅ Installed SkyOffice server dependencies

### Running SkyOffice

#### Development Mode
```bash
# Terminal 1 - Start the server
cd "/home/destinyjade/Inner Shift/SkyOffice/server"
npm run dev

# Terminal 2 - Start the client
cd "/home/destinyjade/Inner Shift/SkyOffice/client"  
npm run dev
```

#### Production Build
```bash
# Build client
cd "/home/destinyjade/Inner Shift/SkyOffice/client"
npm run build

# Start server in production
cd "/home/destinyjade/Inner Shift/SkyOffice/server"
npm start
```

## Architecture Overview

### Frontend (React Client)
- **Location**: `SkyOffice/client/`
- **Key Technologies**:
  - Phaser3 for 2D rendering
  - React for UI components
  - Redux for state management
  - PeerJS for WebRTC (to be replaced with LiveKit)

### Backend (Colyseus Server)
- **Location**: `SkyOffice/server/`
- **Key Technologies**:
  - Colyseus for multiplayer state sync
  - Express.js for HTTP API
  - PeerJS server for WebRTC signaling

### Sprite Assets
- **Entities**: Character sprites (16x16)
- **Environment**: Tileset for building the office
- **Icons**: UI elements and indicators
- **Weapons**: Items and interactive objects

## Next Steps for Development

### Phase 1: Base Platform Setup (Week 1)
- [ ] Configure development environment
- [ ] Test SkyOffice base functionality
- [ ] Document existing features and codebase
- [ ] Set up version control and branching strategy

### Phase 2: LiveKit Integration (Week 2-3)
- [ ] Replace PeerJS with LiveKit for audio/video
- [ ] Implement spatial audio using LiveKit SDK
- [ ] Configure LiveKit server for self-hosting
- [ ] Test proximity-based audio attenuation

### Phase 3: Body Doubling Features (Week 3-4)
- [ ] Add focus status indicators
- [ ] Implement desk assignment system
- [ ] Create quiet zones with audio rules
- [ ] Add session timer and tracking

### Phase 4: Asset Integration (Week 4-5)
- [ ] Replace default sprites with Anokolisa assets
- [ ] Design office layouts and environments
- [ ] Create custom UI components
- [ ] Implement avatar customization

### Phase 5: Deployment (Week 5-6)
- [ ] Set up DigitalOcean VPS ($24/month)
- [ ] Configure Nginx reverse proxy
- [ ] Install SSL certificates
- [ ] Deploy LiveKit server
- [ ] Set up monitoring and logging

## Key Features to Implement

### Core SkyOffice Features (Existing)
- ✅ 2D character movement
- ✅ Room-based multiplayer
- ✅ Proximity-based interactions
- ✅ Text chat
- ✅ Basic screen sharing

### Enhanced Features (To Implement)
- [ ] LiveKit spatial audio integration
- [ ] Directional audio based on avatar position
- [ ] Focus mode indicators
- [ ] Desk reservation system
- [ ] Quiet zones
- [ ] Session analytics
- [ ] Pomodoro timer integration
- [ ] Status indicators (available, busy, in focus)

## Configuration Files

### Environment Variables
Create `.env` files in both client and server directories:

#### Server (.env)
```
NODE_ENV=development
PORT=2567
ADMIN_PASSWORD=your_admin_password
LIVEKIT_API_KEY=your_livekit_key
LIVEKIT_API_SECRET=your_livekit_secret
LIVEKIT_URL=ws://localhost:7880
```

#### Client (.env)
```
REACT_APP_SERVER_URL=http://localhost:2567
REACT_APP_LIVEKIT_URL=ws://localhost:7880
```

## Resource Links

### Documentation
- [SkyOffice GitHub](https://github.com/kevinshen56714/SkyOffice)
- [LiveKit Documentation](https://docs.livekit.io/)
- [Colyseus Documentation](https://docs.colyseus.io/)
- [Phaser3 Documentation](https://phaser.io/phaser3)

### Assets
- [Anokolisa Sprite Pack](https://anokolisa.itch.io/free-pixel-art-asset-pack-topdown-tileset-rpg-16x16-sprites)

### Deployment
- [DigitalOcean VPS](https://cloud.digitalocean.com) - $24/month for 4GB RAM/2vCPU

## Technical Requirements

### Minimum Server Requirements
- 4GB RAM
- 2 vCPU
- 80GB SSD
- Ubuntu 22.04 LTS

### Client Browser Support
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Support & Contact

For issues with the setup or development questions, refer to:
- SkyOffice issues: https://github.com/kevinshen56714/SkyOffice/issues
- LiveKit community: https://livekit.io/community
- Colyseus Discord: https://discord.gg/colyseus

## License Information
- SkyOffice: MIT License
- LiveKit: Apache 2.0 License
- Anokolisa Assets: Free for commercial use
- This project: To be determined

---
*Last Updated: August 8, 2025*
*Project Timeline: 4-6 weeks*
*Monthly Hosting Cost: ~$25/month*