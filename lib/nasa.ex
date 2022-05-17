defmodule NASA.StartMission do

  alias NASA.NasaManager
  alias NASA.ControllerNasa
  alias NASA.Registry

  @calkText "Typing commands: "

  def main(_arg) do
    {:ok, supervisor} = Task.Supervisor.start_link
    stream = Task.Supervisor.async_stream_nolink(supervisor, 1..1, fn item -> 
      command = NasaManager.receiveCommand(@calkText)
      ControllerNasa.calcFuel(command)
    end, timeout: :infinity, max_concurrency: 1)
    |> Stream.run() 
    |> main
  end  
end
