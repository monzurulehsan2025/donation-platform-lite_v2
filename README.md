# Funding MVP API

This is a simple MVP backend for a funding platform built with Ruby and Sinatra. It provides a RESTful API to manage funding opportunities (grants) and grant applications.

## Getting Started

1. Ensure you have Ruby installed.
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Run the server:
   ```bash
   ruby app.rb
   ```
   The server will start locally at `http://localhost:4567`.

---

## API Endpoints

### 1. List All Grants
Retrieves a list of all available funding opportunities.

**Request:**
```bash
curl -X GET http://localhost:4567/api/v1/grants
```

**Sample Response:**
```json
{
  "success": true,
  "count": 3,
  "data": [
    {
      "id": "g_101",
      "title": "Global Community Impact Fund 2026",
      "funder": "Global Philanthropy Foundation",
      "amount": 150000,
      "deadline": "2026-12-31",
      "status": "open",
      "focus_area": "Education & Literacy",
      "description": "Funding for local community programs aimed at improving literacy rates through AI-assisted educational tools."
    },
    ...
  ]
}
```

### 2. Get a Specific Grant
Retrieves detailed information for a specific grant by its ID.

**Request:**
```bash
curl -X GET http://localhost:4567/api/v1/grants/g_101
```

**Sample Response:**
```json
{
  "success": true,
  "data": {
    "id": "g_101",
    "title": "Global Community Impact Fund 2026",
    "funder": "Global Philanthropy Foundation",
    "amount": 150000,
    "deadline": "2026-12-31",
    "status": "open",
    "focus_area": "Education & Literacy",
    "description": "Funding for local community programs aimed at improving literacy rates through AI-assisted educational tools."
  }
}
```

### 3. List All Applications
Retrieves a list of all submitted grant applications.

**Request:**
```bash
curl -X GET http://localhost:4567/api/v1/applications
```

**Sample Response:**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "id": "app_501",
      "grant_id": "g_101",
      "applicant_name": "Tech for Kids Non-profit",
      "requested_amount": 120000,
      "status": "under_review",
      "project_title": "AI Tutors for Underserved Schools",
      "submitted_at": "2026-05-20T10:30:00Z"
    },
    ...
  ]
}
```

### 4. Get a Specific Application
Retrieves the details and status of a specific application by its ID.

**Request:**
```bash
curl -X GET http://localhost:4567/api/v1/applications/app_501
```

**Sample Response:**
```json
{
  "success": true,
  "data": {
    "id": "app_501",
    "grant_id": "g_101",
    "applicant_name": "Tech for Kids Non-profit",
    "requested_amount": 120000,
    "status": "under_review",
    "project_title": "AI Tutors for Underserved Schools",
    "submitted_at": "2026-05-20T10:30:00Z"
  }
}
```

### 5. Submit a New Application
Creates a new grant application.

**Request:**
```bash
curl -X POST http://localhost:4567/api/v1/applications \
     -H "Content-Type: application/json" \
     -d '{
           "grant_id": "g_101",
           "applicant_name": "New Horizons NGO",
           "project_title": "Community Tech Center",
           "requested_amount": 75000
         }'
```

**Sample Response:**
```json
{
  "success": true,
  "message": "Application submitted successfully",
  "data": {
    "id": "app_7482",
    "grant_id": "g_101",
    "applicant_name": "New Horizons NGO",
    "project_title": "Community Tech Center",
    "requested_amount": 75000,
    "status": "submitted",
    "submitted_at": "2026-05-24T21:45:00Z"
  }
}
```

### 6. Update Application Status
Updates the status of an existing application.

**Request:**
```bash
curl -X PUT http://localhost:4567/api/v1/applications/app_501/status \
     -H "Content-Type: application/json" \
     -d '{
           "status": "approved"
         }'
```

**Sample Response:**
```json
{
  "success": true,
  "message": "Application status updated",
  "data": {
    "id": "app_501",
    "grant_id": "g_101",
    "applicant_name": "Tech for Kids Non-profit",
    "requested_amount": 120000,
    "status": "approved",
    "project_title": "AI Tutors for Underserved Schools",
    "submitted_at": "2026-05-20T10:30:00Z"
  }
}
```

### 7. Withdraw an Application
Deletes/withdraws an application by its ID.

**Request:**
```bash
curl -X DELETE http://localhost:4567/api/v1/applications/app_501
```

**Sample Response:**
```json
{
  "success": true,
  "message": "Application withdrawn successfully"
}
```

### 8. List Applications for a Grant
Retrieves all applications submitted for a specific grant.

**Request:**
```bash
curl -X GET http://localhost:4567/api/v1/grants/g_101/applications
```

**Sample Response:**
```json
{
  "success": true,
  "count": 1,
  "data": [
    {
      "id": "app_501",
      "grant_id": "g_101",
      "applicant_name": "Tech for Kids Non-profit",
      "requested_amount": 120000,
      "status": "under_review",
      "project_title": "AI Tutors for Underserved Schools",
      "submitted_at": "2026-05-20T10:30:00Z"
    }
  ]
}
```
