# Job Match Recommendation Engine - Backend (Rails API)

This is the backend API for the Job Match Recommendation Engine, built using Ruby on Rails. The API processes jobseeker and job CSV data and returns job recommendations based on matching skills.

## Installation

### 1. Clone the repository:

```
git clone https://github.com/yourusername/job-match-backend.git
cd job-match-backend
```

### 2. Install dependencies:

```
bundle install
```
### 3. Set up the database:

```
rails db:create
rails db:migrate
```

### 4. Start the Rails server:

```
rails server
```

The API will be available at http://localhost:8000.

## API Endpoints
POST /job_matches

This endpoint receives two CSV files (jobseekers and jobs) and returns job recommendations.
   - Request: Multipart form-data with jobseekers and jobs CSV files.
  
   - Response: JSON with job recommendations sorted by jobseeker and matching skill percentage.
