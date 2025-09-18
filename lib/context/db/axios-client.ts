import { refreshAccessToken } from "./user";
import { router } from "expo-router";
import { secureStorage } from "@/services/secure-storage";
import axios from "axios";
import ROUTES from "constants/routes";

const api = axios.create({
    baseURL: process.env.EXPO_PUBLIC_API_URL,
    headers: {
      'Content-Type': 'application/json',
    },
});

// Add request interceptor to add auth token
api.interceptors.request.use(
    async (config) => {
      const token = await secureStorage.getItem('ACCESS_TOKEN');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      console.error('Request interceptor error:', error);
      return Promise.reject(error);
    }
);

api.interceptors.response.use(
    (response) => response,
    async (error) => {
      const originalRequest = error.config;
  
      if (error.response?.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true;
        try {
          const refreshToken = await secureStorage.getItem('REFRESH_TOKEN');
          if (!refreshToken) {
            console.log('No refresh token available');
            throw new Error('No refresh token available');
          }
  
          const response = await refreshAccessToken(refreshToken);
  
          if (response.access_token) {
            await secureStorage.setItem('ACCESS_TOKEN', response.access_token);
            originalRequest.headers.Authorization = `Bearer ${response.access_token}`;
            return api(originalRequest);
          } else {
            console.error('No access token in refresh response');
            throw new Error('No access token available');
          }
        } catch (refreshError) {
          console.error('Token refresh failed:', refreshError);
          await secureStorage.clearAll();
          router.push(ROUTES.LOGIN);
          return Promise.reject(refreshError);
        }
      }
      return Promise.reject(error);
    }
  );

export default api;