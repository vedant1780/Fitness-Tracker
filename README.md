<div align="center">

<br />



### AI-Powered Full-Stack Expense Tracking & Financial Intelligence Platform

<br />

[![Node.js](https://img.shields.io/badge/Node.js-v20+-339933?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.x-000000?style=flat-square&logo=express&logoColor=white)](https://expressjs.com/)
[![JWT](https://img.shields.io/badge/Auth-JWT%20%2B%20RBAC-FB015B?style=flat-square&logo=jsonwebtokens&logoColor=white)](https://jwt.io/)
[![Gemini](https://img.shields.io/badge/AI-Gemini%20API-4285F4?style=flat-square&logo=google&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-22c55e?style=flat-square)](LICENSE)

<br />

> **Track. Forecast. Understand.** — A production-grade expense platform with real-time AI financial insights, predictive time-series forecasting, and enterprise-grade security.

<br />

---

</div>

## ✦ Overview

**ExpenseAI** is a full-stack financial management platform engineered from the ground up — spanning secure RESTful API architecture, role-based access control, and an AI-powered forecasting engine. Whether you're monitoring personal budgets or managing organization-wide transactions, ExpenseAI delivers actionable intelligence in real time.

The platform demonstrates cross-layer engineering discipline: from JWT-secured API endpoints and concurrent transaction handling on the backend, to a responsive analytics dashboard and Gemini-powered financial chatbot on the frontend.

<br />

## ⚡ Feature Highlights

| Layer | Capability |
|---|---|
| **API** | RESTful endpoints with full CRUD, pagination, and filtering |
| **Auth** | JWT access/refresh tokens + Role-Based Access Control (RBAC) |
| **Concurrency** | Optimistic locking & atomic DB operations for high-throughput requests |
| **Forecasting** | Time-series financial prediction engine (ARIMA-inspired) |
| **AI Chatbot** | Gemini API integration for natural-language financial Q&A |
| **Dashboard** | Real-time analytics with trend charts, category breakdowns, and alerts |
| **Security** | Rate limiting, input sanitization, CORS, Helmet.js hardening |

<br />

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                          │
│           React SPA  ·  Charts  ·  Gemini Chatbot           │
└──────────────────────────┬──────────────────────────────────┘
                           │  HTTPS / REST
┌──────────────────────────▼──────────────────────────────────┐
│                      API GATEWAY                             │
│         Express.js  ·  JWT Middleware  ·  RBAC Guard        │
│         Rate Limiter  ·  Input Validator  ·  Helmet          │
└──────┬─────────────────────────────────┬────────────────────┘
       │                                 │
┌──────▼──────────┐             ┌────────▼────────────────────┐
│  BUSINESS LOGIC │             │      AI / ML ENGINE          │
│  Transaction    │             │  Time-Series Forecasting     │
│  Budget Rules   │             │  Gemini API Integration      │
│  Alert Engine   │             │  Anomaly Detection           │
└──────┬──────────┘             └────────┬────────────────────┘
       │                                 │
┌──────▼─────────────────────────────────▼────────────────────┐
│                       DATA LAYER                             │
│          PostgreSQL  ·  Redis (Session Cache)                │
└─────────────────────────────────────────────────────────────┘
```

<br />

## 🚀 Getting Started

### Prerequisites

- Node.js `v20+`
- PostgreSQL `v15+`
- Redis `v7+`
- A [Google Gemini API key](https://ai.google.dev/)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/expenseai.git
cd expenseai

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
```

Configure your `.env`:

```env
# Server
PORT=5000
NODE_ENV=development

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/expenseai

# Authentication
JWT_SECRET=your-super-secret-jwt-key
JWT_REFRESH_SECRET=your-refresh-secret
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# AI Integration
GEMINI_API_KEY=your-gemini-api-key

# Cache
REDIS_URL=redis://localhost:6379
```

```bash
# Run database migrations
npm run migrate

# Seed sample data (optional)
npm run seed

# Start development server
npm run dev
```

The API will be live at `http://localhost:5000` and the frontend at `http://localhost:3000`.

<br />

## 📡 API Reference

### Authentication

```http
POST   /api/auth/register       Register a new user
POST   /api/auth/login          Obtain JWT access + refresh tokens
POST   /api/auth/refresh        Refresh access token
POST   /api/auth/logout         Revoke refresh token
```

### Transactions

```http
GET    /api/transactions        List transactions (paginated, filterable)
POST   /api/transactions        Create a new transaction
GET    /api/transactions/:id    Get transaction by ID
PUT    /api/transactions/:id    Update transaction
DELETE /api/transactions/:id    Delete transaction
GET    /api/transactions/export Download as CSV/PDF
```

### Budgets & Categories

```http
GET    /api/budgets             List all budgets
POST   /api/budgets             Create budget with alert thresholds
GET    /api/categories          List spending categories
POST   /api/categories          Create custom category
```

### AI & Forecasting

```http
GET    /api/forecast            Time-series forecast (30/60/90-day)
POST   /api/chat                Send message to Gemini financial chatbot
GET    /api/analytics/summary   Dashboard KPIs and trend data
GET    /api/analytics/anomalies Detect unusual spending patterns
```

<br />

### Example: Create a Transaction

```bash
curl -X POST http://localhost:5000/api/transactions \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 49.99,
    "category": "dining",
    "description": "Team lunch",
    "date": "2025-06-05",
    "tags": ["work", "reimbursable"]
  }'
```

**Response:**

```json
{
  "success": true,
  "data": {
    "id": "txn_9k2mxp4r",
    "amount": 49.99,
    "category": "dining",
    "description": "Team lunch",
    "date": "2025-06-05",
    "userId": "usr_ab12cd34",
    "createdAt": "2025-06-05T10:23:44.000Z"
  }
}
```

<br />

## 🔐 Security Model

ExpenseAI implements a layered security architecture:

**Authentication & Authorization**
- Stateless JWT with short-lived access tokens (`15m`) and rotating refresh tokens (`7d`)
- RBAC with three tiers: `viewer` → `editor` → `admin`
- Refresh token rotation with family tracking to detect reuse attacks

**API Hardening**
- Per-route rate limiting (e.g., 5 req/15min on `/auth/login`)
- Input validation and sanitization via `zod` schemas on every endpoint
- SQL injection prevention through parameterized queries (no raw string interpolation)
- Helmet.js for secure HTTP headers (CSP, HSTS, X-Frame-Options)

**Data Integrity**
- Optimistic locking on concurrent transaction writes
- Atomic database operations to prevent partial-update corruption
- Audit log for all mutations (who, what, when)

<br />

## 🤖 AI Forecasting Engine

The forecasting module performs time-series analysis on historical spending data to project future expenses.

```
Historical Transactions
        │
        ▼
  Data Aggregation          ← Group by day/week/category
        │
        ▼
  Trend Decomposition       ← Isolate trend, seasonality, noise
        │
        ▼
  Smoothed Projection       ← Exponential smoothing + seasonal adjustment
        │
        ▼
  Confidence Intervals      ← ±1σ bounds on 30/60/90-day forecasts
        │
        ▼
  Gemini Narrative Layer    ← Natural-language summary of the forecast
```

**Chatbot Integration**

The Gemini-powered chatbot has full context of the user's financial data and can answer questions like:

- *"Am I on track to stay within my grocery budget this month?"*
- *"What were my top 3 spending categories last quarter?"*
- *"Forecast my total expenses for July based on current trends."*

<br />

## 🛠 Tech Stack

**Backend**

| Package | Purpose |
|---|---|
| `express` | HTTP server & routing |
| `jsonwebtoken` | JWT generation & verification |
| `bcryptjs` | Password hashing |
| `zod` | Request schema validation |
| `pg` / `prisma` | PostgreSQL ORM |
| `ioredis` | Redis caching & session store |
| `helmet` | HTTP security headers |
| `express-rate-limit` | Rate limiting middleware |

**Frontend**

| Package | Purpose |
|---|---|
| `react` | UI component framework |
| `recharts` | Financial chart visualizations |
| `axios` | HTTP client with interceptors |
| `zustand` | Lightweight state management |
| `@google/generative-ai` | Gemini chatbot SDK |

<br />

## 🗂 Project Structure

```
expenseai/
├── server/
│   ├── config/            # DB, Redis, environment config
│   ├── controllers/       # Route handler logic
│   ├── middleware/        # Auth, RBAC, validation, rate-limit
│   ├── models/            # Prisma schema & DB models
│   ├── routes/            # Express route definitions
│   ├── services/
│   │   ├── forecast/      # Time-series analysis engine
│   │   ├── gemini/        # AI chatbot integration
│   │   └── analytics/     # KPI aggregation & anomaly detection
│   └── utils/             # Helpers, error handling, logger
│
├── client/
│   ├── components/        # Reusable UI components
│   ├── pages/             # Route-level page components
│   ├── hooks/             # Custom React hooks
│   ├── store/             # Zustand state slices
│   └── services/          # API client wrappers
│
├── prisma/
│   ├── schema.prisma      # Database schema
│   └── migrations/        # Version-controlled DB migrations
│
├── tests/
│   ├── unit/              # Service & utility tests
│   └── integration/       # API endpoint tests
│
└── docker-compose.yml     # Postgres + Redis local setup
```

<br />

## 🧪 Testing

```bash
# Run all tests
npm test

# Unit tests only
npm run test:unit

# Integration tests (requires running DB)
npm run test:integration

# Coverage report
npm run test:coverage
```

<br />

## 📦 Deployment

### Docker

```bash
# Build and run all services
docker-compose up --build

# Production build
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Checklist

- [ ] Set `NODE_ENV=production`
- [ ] Use strong, unique values for all `*_SECRET` variables
- [ ] Enable SSL on PostgreSQL and Redis connections
- [ ] Set `CORS_ORIGIN` to your frontend domain only
- [ ] Configure log aggregation (e.g., Datadog, Logtail)

<br />

## 🤝 Contributing

Contributions are welcome! Please open an issue first to discuss proposed changes.

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push and open a Pull Request

Please follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

<br />

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for full terms.

<br />

---

<div align="center">

Built with precision · Secured by design · Powered by AI

</div>
