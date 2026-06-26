defmodule InspectGuardTest do
  @moduledoc """
  Documentation for `InspectGuardTest`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> InspectGuardTest.hello()
      :world

  """
  def hello do
    secrets = %{
      "mysecret1" => "mykey1",
      "mysecret2" => "mykey2"
    }

    IO.inspect(secrets, label: "HERE ARE MY SECRETS") #io_inspect_ok

    :world
  end
end
