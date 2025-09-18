### Problem Statement
I have a React Native (TypeScript) project that is acting as a Front End for this backend Elixir project. I will be migrating off of a MongoDB backend to use this Elixir Project for the new backend. To do this, I will give you context for the old Data Access Layer (services) that I was using to retreive data from MongoDB. Please see the files for the data access later service here:
`lib/context/db`

### Acceptance Criteria
1. Create TypeScript interfaces that show the request and responses for this backend API.
2. Create the new Data Access Layer services that are based on the old service files that will call this backend Elixir project.
3. The newly created files should be in the `lib/context/solution/db` file.

### Migration Plan Q&A

**Q1: API Base URL**
- **A:** We will use the same environment variable (`process.env.EXPO_PUBLIC_API_URL`), just targeting this Elixir backend as the API endpoint.

**Q2: Authentication**
- **A:** Adapt to use the Elixir session-based authentication instead of Bearer tokens.

**Q3: Data Structure Mapping**
- **A:** Keep the structure as close as possible to the current MongoDB services, with minimal changes (just snake_casing field names, etc.). Create data mappers if necessary to format responses so the services can work with either backend for easy rollback.

**Q4: Error Handling**
- **A:** Create similar error handling pattern designed for Elixir error responses, maintaining the same interface as the current `handleServerResponse` function.

**Q5: Migration Strategy**
- **A:** Create new services that mirror the old ones exactly. Frontend should only need to change the import path to use the new services - everything else should work out of the box.

**Q6: Missing Endpoints**
- **A:** Skip wallet/blockchain related endpoints, shared workouts, and other routes that don't exist in the Elixir backend for now.

**Q7: Testing**
- **A:** Don't create test files for now - focus on the core services.

### Implementation Notes
- Services will be created in `lib/context/solution/db`
- Maintain exact function signatures from original services
- Use Elixir session-based authentication
- Create data mappers for response formatting if needed
- Skip endpoints not available in Elixir backend
- Focus on core workout, exercise, user, and program functionality

### Please ask your questions below