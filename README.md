# SmartPlate

A restaurant management system built as a DBMS course project — one database, five kinds of
user, and a REST API that enforces who is allowed to do what.

SmartPlate models a real restaurant end to end: customers place orders, chefs cook them,
employees receive stock, suppliers quote and deliver ingredients, and a manager sees
everything — menu, recipes, inventory, waste, sales and compliance.

| | |
|---|---|
| **Backend** | Python 3.10+ · FastAPI · 80 REST endpoints |
| **Database** | MySQL — 27 tables, plus stored procedures, triggers and scheduled events |
| **Auth** | JWT (JSON Web Tokens) with role-based access control |
| **Frontend** | Static HTML/CSS/JS dashboards, one per role |

## The five roles

The whole design centres on the idea that one API serves five different people, and the
database decides what each is permitted to see.

| Role | Dashboard | What they can do |
|---|---|---|
| **Customer** | `customer-dashboard.html` | Browse the menu, build an order, add/remove items, track it |
| **Chef** | `chef-dashboard.html` | See the active order queue, move each item through its cooking status |
| **Employee** | `employee-dashboard.html` | View ingredients, compare suppliers, book received stock into batches |
| **Supplier** | `supplier-dashboard.html` | List the ingredients they supply, set pricing, fulfil batch requests |
| **Manager** | `manager-dashboard.html` | Everything: menu, recipes, ingredients, suppliers, users, waste, sales, compliance, logs |

## Where the database does the work

This is a database project, so logic deliberately lives in SQL rather than in Python
wherever it sensibly can:

- **Stored procedures** (`procedures.sql`) — multi-step operations such as adding an item to
  an order, kept atomic in one place.
- **Triggers** (`triggers.sql`, plus the `migration_trg_*` files) — automatic reactions:
  re-ordering stock when an ingredient runs low, raising supply alerts, costing ingredient
  updates, issuing gift codes.
- **Events** (`events.sql`) — scheduled jobs the MySQL server runs on its own timetable.
- **ML schema** (`ml_schema.sql`, `ml_forecast.sql`) — extra tables (sales history, weather
  data) laying the groundwork for demand forecasting.

## Repository layout

```
backend/
  main.py            the FastAPI application — all 80 endpoints
  auth.py            JWT creation/verification and the role guards
  database.py        MySQL connection handling (PyMySQL)
  generate_history.py seeds synthetic sales history
  requirements.txt   pinned Python dependencies
  tests/             pytest smoke tests
Database Creation/
  init_schema.sql    the 27 tables — run this first
  procedures.sql     stored procedures
  triggers.sql       triggers
  events.sql         scheduled events
  dummy_data.sql     sample data to make the dashboards look alive
  ml_schema.sql      forecasting tables
  migration_*.sql    incremental changes applied after the initial schema
  database.png       ER diagram
index.html           login / entry page
*-dashboard.html     one dashboard per role
.env.example         template for your local secrets
```

## Setup

**You need:** Python 3.10 or newer and a running MySQL server.

### 1. Create the database

Run the SQL files in this order (they build on each other):

```bash
mysql -u root -p < "Database Creation/init_schema.sql"
mysql -u root -p < "Database Creation/procedures.sql"
mysql -u root -p < "Database Creation/triggers.sql"
mysql -u root -p < "Database Creation/events.sql"
mysql -u root -p < "Database Creation/ml_schema.sql"
mysql -u root -p < "Database Creation/dummy_data.sql"     # optional sample data
```

Then apply the `migration_*.sql` files.

> Triggers and events only fire if MySQL's scheduler is on:
> `SET GLOBAL event_scheduler = ON;`

### 2. Configure your secrets

Copy the template and fill it in. **Never commit the real `.env`.**

```bash
cp .env.example .env
```

```ini
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=your_mysql_password
DB_NAME=SmartPlate

JWT_SECRET=      # a long random string — the app refuses to start without it
```

`JWT_SECRET` is the key used to sign login tokens. If it is empty or left as the
placeholder, startup fails on purpose.

### 3. Install the Python dependencies

A *virtual environment* (a private folder of libraries, so this project's versions don't
clash with anything else on your machine):

```bash
python3 -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r backend/requirements.txt
```

## Running

```bash
uvicorn backend.main:app --reload
```

`--reload` restarts the server automatically whenever you save a file.

- API: <http://127.0.0.1:8000>
- **Interactive API docs: <http://127.0.0.1:8000/docs>** — FastAPI generates these from the
  code; you can call every endpoint from the browser.
- Health check: <http://127.0.0.1:8000/health>

Open `index.html` to log in, and you'll be sent to the dashboard for your role.

## Tests

```bash
pytest backend/tests
```

## API shape

All endpoints are versioned under `/api/v1/` and namespaced by role, so the URL tells you
who it is for:

```
POST   /api/v1/login                          get a token
POST   /api/v1/register
GET    /api/v1/user/menu                      customer
POST   /api/v1/user/orders
GET    /api/v1/chef/orders/active             chef
GET    /api/v1/employee/ingredients           employee
POST   /api/v1/supplier/supplies              supplier
GET    /api/v1/manager/sales                  manager
```

Every protected route checks the JWT and the caller's role before touching the database.

## License

See [LICENSE](LICENSE). Built as an academic DBMS project.
