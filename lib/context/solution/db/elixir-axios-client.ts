import axios from "axios";
import { router } from "expo-router";
import { secureStorage } from "@/services/secure-storage";
import ROUTES from "constants/routes";

const elixirApi = axios.create({
  baseURL: process.env.EXPO_PUBLIC_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Important for session-based authentication
});

// Add request interceptor for session handling
elixirApi.interceptors.request.use(
  async (config) => {
    // For session-based auth, we don't need to add Authorization headers
    // The session cookie will be automatically sent with withCredentials: true
    return config;
  },
  (error) => {
    console.error('Request interceptor error:', error);
    return Promise.reject(error);
  }
);

// Add response interceptor for session handling
elixirApi.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    // Handle 401 Unauthorized (session expired or invalid)
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      
      try {
        // For session-based auth, we might need to redirect to login
        // or attempt to refresh the session if that's supported
        console.log('Session expired, redirecting to login');
        
        // Clear any stored session data
        await secureStorage.clearAll();
        
        // Redirect to login
        router.push(ROUTES.LOGIN);
        
        return Promise.reject(error);
      } catch (refreshError) {
        console.error('Session refresh failed:', refreshError);
        await secureStorage.clearAll();
        router.push(ROUTES.LOGIN);
        return Promise.reject(refreshError);
      }
    }

    // Handle other errors
    return Promise.reject(error);
  }
);

export default elixirApi;
