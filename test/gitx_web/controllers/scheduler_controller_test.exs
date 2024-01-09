defmodule GitxWeb.SchedulerControllerTest do
  use GitxWeb.ConnCase, async: true

  describe "Scheduler Controller" do
    test "successful scheduler", %{conn: conn} do
      params =
        %{
          "username" => "andridus",
          "repository" => "lx"
        }

      conn = post(conn, ~p"/schedule", params)
      response = json_response(conn, 200)
      assert %{"success" => "scheduled"} = response
    end

    test "username field missing", %{conn: conn} do
      params =
        %{
          "repository" => "lx"
        }

      conn = post(conn, ~p"/schedule", params)
      response = json_response(conn, 422)
      assert %{"error" => "`username` required"} = response
    end

    test "repository field missing", %{conn: conn} do
      params =
        %{
          "username" => "andridus"
        }

      conn = post(conn, ~p"/schedule", params)
      response = json_response(conn, 422)
      assert %{"error" => "`repository` required"} = response
    end

    test "fields missing", %{conn: conn} do
      params = %{}
      conn = post(conn, ~p"/schedule", params)
      response = json_response(conn, 422)
      assert %{"error" => "`username` required"} = response
    end
  end
end
