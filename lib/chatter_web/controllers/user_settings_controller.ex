defmodule ChatterWeb.UserSettingsController do
  use ChatterWeb, :controller

  alias Chatter.Account
  alias ChatterWeb.UserAuth

  plug :assign_displayname_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => act} = params) do
    case act do
      "update_displayname" ->
        update_name(conn, params)
      "update_password" ->
        update_pw(conn, params)
    end
  end

  defp update_name(conn, params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user
    case Account.update_user_displayname(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Displayname updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", displayname_changeset: changeset)
    end
  end

  defp update_pw(conn, params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Account.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)
      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_displayname_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:displayname_changeset, Account.change_user_displayname(user))
    |> assign(:password_changeset, Account.change_user_password(user))
  end

end
