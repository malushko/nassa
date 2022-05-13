defmodule NASA.ControllerNasa do
  alias NASA.NasaManager
  def calcFuel(command) do
    # parsing mass ship
    try do
      massShip = NasaManager.parseMassShip(command)

      #parsing args [:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]
      parsArg = NasaManager.parseArgsMission(command)

      #calk weight of fuel
      %{fuel: weightOfFuel} =
      parsArg
      |> Enum.reverse
      |> Enum.reduce(%{mass: massShip, fuel: 0}, fn [atom, gravity], acc -> 
        calk = NasaManager.calculateFuel(atom, acc.mass, gravity) 
        fuelAndMass = calk + acc.mass
        fuelMass = calk + acc.fuel
        acc = %{mass: fuelAndMass, fuel: fuelMass}
      end)
      
      planetsTask = NasaManager.getPlanetsTask(parsArg)

      objectInfo = %{
        "mission" => NasaManager.getMission(planetsTask),
        "planets_task" => NasaManager.getPlanetsTask(parsArg),
        "weight_of_fuel" => weightOfFuel,
        "mass_ship" => massShip,
        "arguments" => command
      }

      NasaManager.responce(objectInfo)
    catch
      _, _ -> NasaManager.sendErrorMessage
    end  
  end
end
