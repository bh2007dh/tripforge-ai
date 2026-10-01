# 🌍 TripForge AI — Complete Travel Package Builder & Booking Ecosystem

TripForge AI is a full-stack Indian travel package builder and RedBus-style seat reservation platform powered by **Node.js 20, Express, MySQL 8, Vanilla JS / HTML5 / CSS3**, and **Claude AI** (`claude-sonnet-4-6` with built-in zero-latency local fallback heuristics).

---

## ⚡ Quick Start (Run with 1 Command)

```bash
# 1. Install dependencies
npm install

# 2. (Optional) Initialize MySQL database with schema & 24+ seed packages
npm run db:init

# 3. Start the production application
npm start

# 4. Run automated end-to-end test suite
npm test
```

Once running, visit: **[http://localhost:3000](http://localhost:3000)**

---

## 🔑 Demo Accounts (Pre-configured)

| Role | Email | Password | Access |
|---|---|---|---|
| **Traveler** | `traveler@tripforge.com` | `traveler123` | Explorer, Booking, Seat selection, My Trips, Wishlist, Disruption Guardian |
| **Admin** | `admin@tripforge.com` | `admin123` | Analytics dashboard, Demand forecast, Dynamic pricing, Fraud detection, Customer management |

---

## 📂 Project Architecture

```
d:/suji project/
├── .env                     # Environment configuration (Port, MySQL, JWT, Claude API, Razorpay)
├── .env.example             # Example environment template
├── package.json             # Scripts & dependencies
├── README.md                # Documentation & deployment guide
├── sql/
│   ├── schema.sql           # 15 relational MySQL tables, foreign keys & indexes
│   └── seed.sql             # 24+ Indian destination packages, demo users, seats & departures
├── scripts/
│   └── initDb.js            # Automated MySQL database initializer script (`npm run db:init`)
├── server/
│   ├── app.js               # Express application with Helmet, CORS, rate-limiting & static public
│   ├── server.js            # Server entry point
│   ├── config/
│   │   ├── env.js           # Environment parser & defaults
│   │   └── db.js            # mysql2 connection pool with transactional locks + in-memory fallback
│   ├── middleware/
│   │   ├── auth.js          # JWT authentication and requireAdmin role protection
│   │   ├── errorHandler.js  # Uniform JSON error handler
│   │   ├── rateLimiter.js   # Rate limiters for auth and AI endpoints
│   │   └── validator.js     # Zod schema validation
│   ├── routes/              # RESTful API routes (/api/v1/*)
│   ├── services/
│   │   ├── ai.service.js    # Claude API integration (EN/TA/HI) + local fallback parser
│   │   ├── booking.service.js # Authoritative server-side pricing & transactional booking
│   │   ├── seat.service.js  # RedBus-style seat map & 10-min hold lock with SELECT FOR UPDATE
│   │   ├── payment.service.js # Razorpay order creation & HMAC verification + Demo checkout
│   │   ├── pricing.service.js # Price predictor & dynamic yield management
│   │   └── email.service.js # E-Ticket digital boarding pass email delivery
│   └── utils/
│       ├── scoring.js       # 4-dimension match score (Budget 35%, Vibe 35%, Crowd 15%, Transit 15%)
│       └── refund.js        # Authoritative refund calculator (>7d: 100%, 2-7d: 50%, <48h: 0%)
├── public/                  # Multi-page front end (No build step required)
│   ├── index.html           # Home, AI Chat Composer, Mood-Board, Featured packages
│   ├── packages.html        # Filterable package explorer with search, sorting & pagination
│   ├── package.html         # Detail view with Leaflet map, day itinerary, live budget slider, reviews
│   ├── booking.html         # RedBus-style seat map selection, passenger manifest, QR E-Ticket pass
│   ├── trips.html           # My Trips (upcoming/past/cancelled), refund rules & Disruption Guardian
│   ├── wishlist.html        # Bookmarked favorites
│   ├── compare.html         # 3-way side-by-side package comparator
│   ├── group.html           # Group Consensus Engine with Nash-fairness score & radar charts
│   ├── notifications.html   # Notification Center
│   ├── login.html           # Sign In
│   ├── register.html        # Sign Up
│   ├── admin.html           # Admin Intelligence Center, Chart.js demand forecast & fraud detector
│   ├── css/
│   │   ├── main.css         # CSS variables, dark/light theme tokens, typography, layouts
│   │   ├── components.css   # RedBus seat grid, badges, timeline, sliders, toasts
│   │   └── responsive.css   # Mobile-first navigation drawer & bottom navbar
│   └── js/                  # Vanilla ES modules (api.js, auth.js, theme.js, nav.js, toast.js)
└── tests/
    └── api.test.js          # Automated end-to-end test suite
```

---

## 🧳 Traveler Features (Detailed)

1. **AI Chat Trip Composer**:
   - Natural conversational input in **English**, **தமிழ் (Tamil)**, **हिंदी (Hindi)**, or **Tanglish/Hinglish**.
   - Extracts duration, budget cap, party size, travel vibe, and matching packages.
2. **Mood-Board Vibe Selector**:
   - Visual categories: 🏔️ Mountains, 🏖️ Beach, 🏰 Royal Heritage, 🌿 Rainforest, 🧘 Spiritual, 🐅 Wildlife, 🛶 Backwaters.
3. **RedBus-Style Seat Selection**:
   - Interactive 2x2 bus seating grid (Seats 1A-6D) with 10-minute hold locking. Double booking is impossible due to MySQL `SELECT ... FOR UPDATE` transactions.
4. **Live Dynamic Budget Optimizer**:
   - Real-time adjustment for hotel tiers (Hostel -15%, Standard 100%, Luxury Haveli +35%) with instant recalculated fares.
5. **Explainable AI Match Score**:
   - 4-factor scoring breakdown: Budget Fit (35%), Vibe Alignment (35%), Crowd Solitude (15%), Transit Feasibility (15%).
6. **Price Predictor**:
   - "Book Now" vs "Wait" recommendation backed by confidence scores and 14-day historical trend analysis.
7. **Carbon Meter & Greener Alternative**:
   - Calculated CO2e footprint with an eco-switch alternative saving up to 45% emissions.
8. **Group Consensus Engine**:
   - Multi-member voting simulator calculating **Nash-Fairness Score %** and radar charts.
9. **Disruption Guardian**:
   - Real-time contingency planner for heavy rain, highway jams, monument closures, and heatwaves.
10. **QR E-Ticket Boarding Pass**:
    - Instantly generates authenticated digital boarding pass with scannable **QRCode.js** barcode and printable PDF view.
11. **Cancellation & Authoritative Refund Policy**:
    - Automatic tier calculations: 100% refund (> 7 days), 50% refund (2 to 7 days), 0% non-refundable (< 48 hours).

---

## 🛡️ Admin Operations (Detailed)

1. **KPI Dashboard**: Gross Confirmed Revenue, Active Bookings, Cancellations, and Registered Travelers.
2. **AI Demand Forecast**: 6-month predictive demand curves using Chart.js with regional seasonal surge factors.
3. **Dynamic Pricing (Yield Engine)**: Automated surge (+12%) and flash discount (-10%) recommendations with 1-click publishing.
4. **Fraud & Bot Anomaly Detector**: Risk classification scoring tracking disposable email domains, velocity anomalies, and large party sizes.
5. **Customer Management**: Search, view bookings, and suspend/re-activate traveler accounts.
6. **Package Manager**: Form to publish custom Indian travel packages.

---

## 🚀 Deployment Guide (Render / Railway / VPS)

### Deploying to Render / Railway:
1. Create a MySQL database instance (e.g. Railway MySQL or PlanetScale).
2. Set Environment Variables:
   - `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
   - `JWT_SECRET`
   - `ANTHROPIC_API_KEY` (Optional)
   - `RAZORPAY_KEY_ID` & `RAZORPAY_KEY_SECRET` (Optional)
3. Set Build Command: `npm install`
4. Set Start Command: `npm run db:init && npm start`
