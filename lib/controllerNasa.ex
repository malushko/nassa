defmodule NASA.ControllerNasa do
  alias NASA.NasaManager
  def calcFuel(command) do

    # parsing mass ship
    massShip = NasaManager.parseMassShip(command)

    #parsing args [:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]
    parsArg = NasaManager.parseArgsMission(command)

    #calk weight of fuel
    weightOfFuel =
    parsArg
    |> Enum.map(fn [atom, gravity] -> NasaManager.calculateFuel(atom, massShip, gravity) end)
    |> Enum.sum
    |> round 

    planetsTask = NasaManager.getPlanetsTask(parsArg)

    objectInfo = %{
      "mission" => NasaManager.getMission(planetsTask),
      "planets_task" => NasaManager.getPlanetsTask(parsArg),
      "weight_of_fuel" => weightOfFuel,
      "mass_ship" => massShip,
      "arguments" => command
    }

    NasaManager.responce(objectInfo)
  end
end
