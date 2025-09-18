// Program-related types
export interface ElixirProgram {
  id: number;
  name: string;
  user_id: number;
}

// Frontend compatibility types
export interface Program {
  id: string;
  name: string;
  user_id: string;
}
