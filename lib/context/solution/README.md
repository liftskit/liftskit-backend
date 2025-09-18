# Elixir Backend Services

This directory contains the new data access layer services that replace the MongoDB backend with the Elixir backend.

## Structure

```
lib/context/solution/db/
├── types/                    # TypeScript interfaces organized by domain
│   ├── auth.ts              # Authentication types
│   ├── exercise.ts          # Exercise-related types
│   ├── workout.ts           # Workout-related types
│   ├── program.ts           # Program-related types
│   ├── one-rep-max.ts       # One rep max types
│   ├── common.ts            # Common response and request types
│   ├── user.ts              # User-related types
│   ├── tag.ts               # Tag-related types
│   └── index.ts             # Re-exports all types
├── user.ts                  # User service
├── workout.ts               # Workout service
├── workout_performed.ts     # Workout performed service
├── exercises.ts             # Exercise service
├── program-block.ts         # Program block service
├── one-rep-max.ts          # One rep max service
├── data-mapper.ts           # Data mapping utilities
├── handle-elixir-response.ts # Elixir response handling
├── elixir-axios-client.ts   # Axios client for Elixir backend
├── elixir-routes.ts         # Route definitions
├── types.ts                 # Re-exports all types (legacy)
└── index.ts                 # Re-exports all services and utilities
```

## Key Features

### 1. **Type Safety**
- Comprehensive TypeScript interfaces for all Elixir backend entities
- Separate type files for better organization and maintainability
- Compatibility types that maintain the same structure as the old MongoDB services

### 2. **Data Mapping**
- `DataMapper` class to convert between Elixir backend responses and frontend-compatible data structures
- Automatic conversion of numeric IDs to strings for compatibility
- Handles nested relationships and arrays

### 3. **Session-Based Authentication**
- Adapted from Bearer token authentication to Elixir session-based authentication
- Automatic session handling with `withCredentials: true`
- Proper error handling for expired sessions

### 4. **Error Handling**
- `handleElixirResponse` utility for consistent error handling
- Support for Elixir error response format
- Helper functions for list and single item responses

### 5. **Service Compatibility**
- All services maintain the exact same function signatures as the original MongoDB services
- Frontend code only needs to change the import path
- Graceful fallbacks for missing functionality

## Usage

### Basic Import
```typescript
// Import all services
import * as ElixirServices from '@/lib/context/solution/db';

// Or import specific services
import { getUserInfo, signIn } from '@/lib/context/solution/db';
```

### Authentication
```typescript
import { signIn, signUp } from '@/lib/context/solution/db';

// Sign in with email and password
const authResponse = await signIn('user@example.com', 'password');

// Sign up with username, email, and password
const signUpResponse = await signUp('username', 'user@example.com', 'password');
```

### User Operations
```typescript
import { getUserInfo, listAllUsers } from '@/lib/context/solution/db';

// Get user info (accessToken parameter kept for compatibility)
const userInfo = await getUserInfo('username', 'accessToken');

// List all users
const allUsers = await listAllUsers('accessToken');
```

### Workout Operations
```typescript
import { getWorkout, postWorkout } from '@/lib/context/solution/db';

// Get workout by program and name
const workout = await getWorkout('username', 'programName', 'workoutName', 'accessToken');

// Create new workout
const newWorkout = await postWorkout('username', 'programName', 'workoutName', workoutData, 'accessToken');
```

## Migration Notes

### 1. **Missing Functionality**
Some endpoints from the original MongoDB backend are not implemented in the Elixir backend:
- Wallet/blockchain functionality
- Shared workouts
- Password recovery
- Balance checking
- Followed programs

These functions throw appropriate errors or return empty results.

### 2. **Authentication Changes**
- Changed from Bearer token authentication to session-based authentication
- `accessToken` parameters are kept for compatibility but not used
- Session cookies are automatically handled by the browser

### 3. **Data Structure Differences**
- Elixir backend uses numeric IDs, converted to strings for compatibility
- Some nested relationships may have different structures
- Data mapper handles these differences transparently

### 4. **User Filtering**
- Some services currently return all data instead of filtering by user
- This is noted in the code and should be implemented on the backend for production

## Environment Configuration

The services use the same environment variable as the original services:
```bash
EXPO_PUBLIC_API_URL=http://localhost:4000
```

## Testing

To test the new services:
1. Ensure your Elixir backend is running
2. Update your frontend imports to use the new services
3. Test authentication and basic CRUD operations
4. Verify data mapping works correctly

## Rollback Strategy

If you need to rollback to the MongoDB backend:
1. Simply change the import paths back to the original services
2. The function signatures are identical
3. No other code changes are required

## Future Improvements

1. **Backend Enhancements**
   - Implement proper user filtering on the backend
   - Add missing endpoints (wallet, shared workouts, etc.)
   - Implement proper session management

2. **Service Enhancements**
   - Add caching layer
   - Implement retry logic for failed requests
   - Add request/response logging

3. **Type Safety**
   - Add runtime type validation
   - Implement stricter error types
   - Add API response validation
