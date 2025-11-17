# gifmachine — Real-time GIF Wall (2025 Dockerized Version)

Live right now → http://98.81.145.125

A simple, fast, real-time GIF wall with WebSocket updates and optional meme text overlay.  
Post a GIF from anywhere — everyone connected sees it instantly.

Originally created by Salsify • Dockerized & production-hardened in November 2025.

### What it does
- Full-screen GIF feed with real-time updates (no refresh needed)
- Optional top/bottom meme text (classic Impact font)
- Simple shared-secret protection for posting
- Designed for TVs, monitors, Raspberry Pi, or just fun on a spare screen

### Production Deploy (One Command)

```bash
docker run -d \
  --name gifmachine \
  --restart unless-stopped \
  -p 80:4567 \
  -e DATABASE_URL="postgres://gifadmin:YOUR_PASSWORD@your-rds-host.us-east-1.rds.amazonaws.com:5432/gifmachine?sslmode=require" \
  -e GIFMACHINE_PASSWORD=mySuperSecret \
  salsify/gifmachine:latest
```

That’s it. The container automatically runs migrations on first start.

### How to Post a GIF

```bash
curl -X POST http://your-server-ip/gif \
  -d "url=https://i.imgur.com/JBczW4E.gif" \
  -d "who=YourName" \
  -d "secret=mySuperSecret" \
  -d "meme_top=TOP TEXT" \
  -d "meme_bottom=BOTTOM TEXT"
```

Required: url, who, secret  
Optional: meme_top, meme_bottom

### Required Environment Variables

| Variable             | Description                                      | Example |
|----------------------|--------------------------------------------------|---------|
| DATABASE_URL         | PostgreSQL connection with SSL                  | postgres://user:pass@host:5432/db?sslmode=require |
| GIFMACHINE_PASSWORD  | Secret used for posting                         | mySuperSecret |

### What We Fixed to Make It Work in 2025

| Problem                                   | Solution |
|-------------------------------------------|----------|
| relation "gifs" does not exist            | Added ?sslmode=require to DATABASE_URL (AWS RDS enforces SSL) |
| Connection refused / password auth failed | Used full DATABASE_URL (higher priority than separate DB_* vars) |
| Container crashing on start               | Correct SSL + valid credentials → migrations finally run |
| WebSocket issues on some networks         | Exposed on port 80 instead of 4567 |

App has been running 24/7 without issues since November 17, 2025.

### Local Development (non-Docker)

```bash
rvm install 2.6.5
gem install bundler
bundle install
createdb gifmachine
export RACK_ENV=development
export GIFMACHINE_PASSWORD=dev
bundle exec rake db:migrate
ruby app.rb -o 0.0.0.0
```

Then open http://localhost:4567

### Original Credits

Created by Salsify  
https://github.com/salsify/gifmachine

Dockerized, SSL-fixed, and production-ready in 2025.

Enjoy the GIFs!
