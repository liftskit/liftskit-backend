defmodule LiftskitBackendWeb.UserController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Users
  alias LiftskitBackend.Accounts.User

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def search(conn, %{"username" => username} = params) do
    IO.puts("username: #{username}")
    IO.puts("params: #{inspect(params)}")
    users = Users.search_users_by_username(conn.assigns.current_scope, username)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"user" => user_params}) do
    current_user = conn.assigns.current_scope.user

    with {:ok, %User{} = user} <- Users.update_current_user(current_user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
