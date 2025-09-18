import { ServerResponse } from "types/server-response";

export const handleServerResponse = (response: ServerResponse) => {
  if (response.success) {
    return response.data;
  }

  throw new Error(response.message);
};

