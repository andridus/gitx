defmodule Swapex.Mock.State do
  @moduledoc """
    State for manipulate mock test based
  """
  use HTTPMock.State

  entity(:request, default: [], key: :id)
  entity(:limits, default: [], key: :id)

  def set_rate_limit(limit) do
    delete(:limits, 1)
    create(:limits, %{id: 1, limit: limit})
  end

  def access(endpoint) do
    one(:limits, 1)
    |> case do
      nil ->
        :ok

      limit ->
        all_requests = all(:request) |> length()

        if all_requests < limit.limit do
          id = Faker.UUID.v4()
          create(:request, %{id: id, endpoint: endpoint, created_at: DateTime.utc_now()})
          :ok
        else
          reset()
          set_rate_limit(limit.limit)
          :rate_limit
        end
    end
  end
end
