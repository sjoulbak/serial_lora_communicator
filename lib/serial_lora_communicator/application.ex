defmodule SerialLoraCommunicator.Application do
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  alias SerialLoraCommunicator.Serial.UartGenServer

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: SerialLoraCommunicator.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  def children(_target) do
    [
      UartGenServer
    ]
  end
end
