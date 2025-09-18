import { ElixirErrorResponse } from './types';

export const handleElixirResponse = <T>(response: any): T => {
  // Check if response has an error field (Elixir error response)
  if (response && response.error) {
    const errorResponse = response as ElixirErrorResponse;
    throw new Error(errorResponse.error);
  }

  // Check if response has a data field (Elixir success response)
  if (response && response.data !== undefined) {
    return response.data;
  }

  // If response is already the data (direct response)
  if (response && response.data === undefined && !response.error) {
    return response;
  }

  // Fallback: return the response as-is
  return response;
};

// Helper function to handle Elixir list responses
export const handleElixirListResponse = <T>(response: any): T[] => {
  const data = handleElixirResponse<T[]>(response);
  
  // Ensure we always return an array
  if (Array.isArray(data)) {
    return data;
  }
  
  // If data is not an array, wrap it or return empty array
  if (data && typeof data === 'object') {
    // If it's a single item, wrap it in an array
    return [data as T];
  }
  
  return [];
};

// Helper function to handle Elixir single item responses
export const handleElixirSingleResponse = <T>(response: any): T => {
  const data = handleElixirResponse<T>(response);
  
  // If data is an array with one item, return the first item
  if (Array.isArray(data) && data.length > 0) {
    return data[0];
  }
  
  // If data is an array but empty, throw an error
  if (Array.isArray(data) && data.length === 0) {
    throw new Error('No data found');
  }
  
  return data;
};
