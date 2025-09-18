// Authentication types
export interface SignInRequest {
  email: string;
  password: string;
}

export interface SignUpRequest {
  username: string;
  email: string;
  password: string;
}

export interface AuthResponse {
  user: ElixirUser;
  token?: string; // If using session-based auth, this might not be needed
}

// Import the ElixirUser type
export interface ElixirUser {
  id: number;
  username: string;
  email: string;
}
