defmodule SerialLoraCommunicator.Serial.UartGenServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    {:ok, pid} = Nerves.UART.start_link()

    state = %{
      pid: pid,
      disconnected_names: ["ttyUSB0"]
    }

    {:ok, state, 1000}
  end


  def handle_info({:nerves_uart, name, {:error, :eio}}, state) do
    {:noreply, Map.merge(state, %{disconnected_names: state.disconnected_names ++ [name]}), 1000}
  end
  def handle_info({:nerves_uart, name, text}, state) do
    IO.inspect("----[*]----")
    IO.inspect(name)
    IO.inspect(text)

    {:noreply, state}
  end

  def handle_info(:timeout, %{disconnected_names: disconnected_names} = state) when length(disconnected_names) > 0 do
    disconnected_names = Enum.reject(disconnected_names, fn(name) ->
      case Nerves.UART.open(state.pid, name, speed: 9600, active: true) do
        :ok -> true
        _ -> false
      end
    end)

    state = Map.merge(state, %{disconnected_names: disconnected_names})
    if length(disconnected_names) > 0 do
      {:noreply, state, 1000}
    else
      {:noreply, state}
    end
  end
  def handle_info(:timeout, state), do: {:noreply, state}
end