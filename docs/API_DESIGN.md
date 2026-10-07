# Blood Bank Management API Design

This document outlines the core RESTful endpoints for the Blood Bank Management System.

---

## 1. Donors

### `GET /api/donors`
Retrieves a paginated list of donors.

**Query Parameters:**
* `page`: integer (default 1)
* `pageSize`: integer (default 20)
* `bloodType`: string (optional filter)

**Responses:**
* `200 OK`: Returns list of donors.

### `GET /api/donors/{id}`
Retrieves a specific donor's profile, including their donation history and eligibility status.

**Responses:**
* `200 OK`: Returns donor details.
* `404 Not Found`: Donor does not exist.

### `POST /api/donors`
Registers a new donor.

**Request Body:**
```json
{
  "firstName": "Mohammad",
  "lastName": "Khalid",
  "nationalId": "123456789",
  "bloodType": "O_Positive",
  "gender": "Male",
  "dateOfBirth": "1990-01-01",
  "contactNumber": "+1234567890"
}
```

**Responses:**
* `201 Created`: Donor registered successfully.
* `400 Bad Request`: Validation errors.

---

## 2. Donations & Blood Units

### `POST /api/donations`
Records a new blood donation from an eligible donor. This automatically creates a new Blood Unit in `Quarantined` status.

**Request Body:**
```json
{
  "donorId": "uuid-string",
  "volumeMl": 450,
  "collectionDate": "2026-09-29T10:00:00Z"
}
```

**Responses:**
* `201 Created`: Donation recorded and unit created.
* `400 Bad Request`: Donor ineligible (e.g., within cooldown period).

### `GET /api/inventory/units`
Retrieves the current inventory of blood units.

**Query Parameters:**
* `status`: string (e.g., `Available`, `Quarantined`, `Expired`)
* `bloodType`: string

**Responses:**
* `200 OK`: List of blood units.

### `PUT /api/inventory/units/{id}/status`
Updates the status of a specific blood unit (e.g., after testing is complete).

**Request Body:**
```json
{
  "status": "Available",
  "notes": "Testing cleared for all standard panels."
}
```

**Responses:**
* `204 No Content`: Status updated.
* `404 Not Found`: Unit not found.

---

## 3. Hospital Requests

### `POST /api/requests`
Submits a new request from a hospital for blood units.

**Request Body:**
```json
{
  "hospitalId": "uuid-string",
  "patientName": "Jane Smith",
  "bloodType": "A_Negative",
  "unitsRequired": 2,
  "urgency": "High"
}
```

**Responses:**
* `201 Created`: Request submitted and set to `Pending` status.

### `POST /api/requests/{id}/fulfill`
Fulfills a hospital request by assigning specific available blood units to it. This changes the unit statuses to `Issued` and generates a `TransactionType.Dispatch`.

**Request Body:**
```json
{
  "assignedUnitIds": [
    "unit-uuid-1",
    "unit-uuid-2"
  ]
}
```

**Responses:**
* `200 OK`: Request fulfilled successfully.
* `400 Bad Request`: Units are not available or incompatible.

---

## 4. Wallet & Transactions

### `GET /api/transactions`
Retrieves a history of inventory transactions (deposits, dispatches, discards).

**Responses:**
* `200 OK`: List of transactions.

---

## 5. Authentication

### `POST /api/auth/register`
Registers a new user (donor) from the mobile app.

**Request Body:**
```json
{
  "firstName": "Mohammad",
  "lastName": "Khalid",
  "gender": "male",
  "nationalID": "123456789",
  "email": "user@example.com",
  "phone": "0791234567",
  "date": "1990-01-01",
  "password": "123456",
  "passwordConfirm": "123456"
}
```

**Responses:**
* `201 Created`: User registered successfully.
* `400 Bad Request`: Validation errors.

### `POST /api/auth/login`
Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "nationalID": "123456789",
  "password": "123456"
}
```

**Responses:**
* `200 OK`: Successful login. Returns `{"token": "jwt-token-string"}`.
* `401 Unauthorized`: Invalid credentials.

---

## 6. User Profile (Mobile App)

### `GET /api/user/credit`
Retrieves the logged-in user's blood units balance (credit). Requires JWT Authentication.

**Responses:**
* `200 OK`: Returns the credit balance, e.g., `{"credit": 2.0}`.

### `GET /api/user/visits`
Retrieves the logged-in user's donation visits/history. Requires JWT Authentication.

**Responses:**
* `200 OK`: Returns a list of visits.
