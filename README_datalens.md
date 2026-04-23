# DataLens — Local Data Analytics Platform

A browser-based analytics platform that lets users upload CSV/Excel files, run SQL queries, build charts, and get AI-powered insights — all processed **locally** with zero cloud dependency. Designed as a privacy-first alternative to Power BI and Tableau for users who can't send their data to third-party services.

## Why This Exists

Traditional BI tools (Power BI, Tableau, Looker) require uploading data to the cloud or to a vendor-controlled environment. For regulated industries (healthcare, finance, legal) or for sensitive personal data, that's a non-starter. DataLens runs entirely in the browser, so your data never leaves your machine.

## Tech Stack

- **Frontend:** React
- **Backend / Query Engine:** Python, SQL
- **Data Handling:** Pandas (via pyodide / local runtime)

## Features

- Upload CSV and Excel files directly in-browser
- Run full SQL queries against uploaded data
- Build charts (bar, line, pie, scatter) with no-code UI
- AI-powered insight generation on demand
- Zero data leaves the device — fully local processing

## Getting Started

```bash
# Clone the repo
git clone https://github.com/sharathchavali/datalens.git
cd datalens

# Install dependencies
npm install

# Run the dev server
npm run dev
```

Then open `http://localhost:3000` and upload a CSV or Excel file to start exploring.

## Status

Active development. Contributions and feedback welcome.

## Author

Sharath Chandra Chavali — Data Analyst
