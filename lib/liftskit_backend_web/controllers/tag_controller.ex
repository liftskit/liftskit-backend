defmodule LiftskitBackendWeb.TagController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Tags
  alias LiftskitBackend.Tags.Tag

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    tags = Tags.list_tags(conn.assigns.current_scope)
    render(conn, :index, tags: tags)
  end

  def create(conn, tag_params) do
    with {:ok, %Tag{} = tag} <- Tags.create_tag(conn.assigns.current_scope, tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tags/#{tag}")
      |> render(:show, tag: tag)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Tags.get_tag!(conn.assigns.current_scope, id)
    render(conn, :show, tag: tag)
  end

  def update(conn, %{"id" => id} = params) do
    tag = Tags.get_tag!(conn.assigns.current_scope, id)
    tag_params = Map.drop(params, ["id"])

    with {:ok, %Tag{} = tag} <- Tags.update_tag(conn.assigns.current_scope, tag, tag_params) do
      render(conn, :show, tag: tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Tags.get_tag!(conn.assigns.current_scope, id)

    with {:ok, %Tag{}} <- Tags.delete_tag(conn.assigns.current_scope, tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
