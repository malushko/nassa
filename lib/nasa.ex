defmodule NASA.StartMission do

  alias NASA.NasaManager
  alias NASA.ControllerNasa
  alias NASA.Supervisor
  alias NASA.Registry

  @calkText "Typing commands, for example: 28801, [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]] "

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
