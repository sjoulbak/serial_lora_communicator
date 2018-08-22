defmodule SerialLoraCommunicator.Serial.UartGenServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(_) do
    {:ok, pid} = Nerves.UART.start_link()

    state = %{
      pid: pid,
      disconnected_names: ["ttyUSB0"],
      failed_commands: []
    }

    {:ok, state, 1000}
  end

  def handle_cast({:send_command, command}, state) do
    failed_commands = case send_command(command, state) do
      :ok -> state.failed_commands
      _ -> state.failed_commands ++ [command]
    end

    {:noreply, Map.merge(state, %{failed_commands: failed_commands}), 1000}
  end

  def handle_info({:nerves_uart, "ttyUSB0" = name, {:error, :eio}}, state) do
    {:noreply, Map.merge(state, %{disconnected_names: state.disconnected_names ++ [name]}), 1000}
  end
  def handle_info({:nerves_uart, "ttyUSB0", text}, state) do
    IO.inspect("----[*]----")
    IO.inspect(text)

    {:noreply, state}
  end
  def handle_info({:nerves_uart, _, _}, state), do: {:noreply, state}

  def handle_info(:timeout, %{disconnected_names: disconnected_names} = state) when length(disconnected_names) > 0 do
    disconnected_names = Enum.reject(disconnected_names, fn(name) ->
      case Nerves.UART.open(state.pid, name, speed: 9600, active: true) do
        :ok -> true
        _ -> false
      end
    end)

    {:noreply, Map.merge(state, %{disconnected_names: disconnected_names}), 1000}
  end
  def handle_info(:timeout, %{failed_commands: failed_commands} = state) when length(failed_commands) > 0 do
    failed_commands = Enum.reject(failed_commands, fn(command) ->
      case send_command(command, state) do
        :ok -> true
        _ -> false
      end
    end)

    {:noreply, Map.merge(state, %{failed_commands: failed_commands}), 1000}
  end
  def handle_info(:timeout, state), do: {:noreply, state}

  defp send_command(_, %{disconnected_names: disconnected_names}) when length(disconnected_names) > 0, do: :error
  defp send_command(command, %{pid: pid}), do: Nerves.UART.write(pid, command)
end
