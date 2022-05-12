defmodule NASA.NasaManager do
  import IO.ANSI

  @gravitysPlanet  %{
    "earth" => 9.807,
    "moon" => 1.62,
    "mars" => 3.711
   }

   @missions %{
     "Apollo 11" => "launch Earth, land Moon, launch Moon, land Earth",
     "Mission on Mars" => "launch Earth, land Mars, launch Mars, land Earth",
     "Passenger ship" => "launch Earth, land Moon, launch Moon, land Mars, launch Mars, land Earth"
   }


  def calculateFuel(a, mass \\ nil, gravity \\ nil, acum \\ [])

  def calculateFuel(:launch, mass, gravity, acum) do
    case mass * gravity * 0.042 - 33 do
      item when item > 0 ->
        newArr = acum ++ [item]
        calculateFuel(:launch, item, gravity, newArr)
      _ -> acum |> Enum.sum
    end
  end

  def calculateFuel(:land, mass, gravity, acum)  do
    case mass * gravity * 0.033 - 42 do
      item when item > 0 ->
        newArr = acum ++ [item]
        calculateFuel(:launch, item, gravity, newArr)
      _ -> acum |> Enum.sum
    end
  end

  def parseMassShip(command) do
    command
    |> then(&Regex.named_captures(~r/(?<mass>\d+)/, &1))
    |> Map.get("mass")
    |> String.to_integer
  end

  def parseArgsMission(command) do
    command
    |> then(&Regex.replace(~r/ /, &1, ""))
    |> then(&Regex.scan(~r/(launch|land),([0-9\.]+)/, &1, capture: :all_but_first))
    |> Enum.map(fn [atom, gravity] -> [String.to_atom(atom), String.to_float(gravity)] end)
  end

  def getPlanetsTask(pars_arg) do
    pars_arg
    |> Enum.map(fn [atom, gravity] ->
      string_atom = Atom.to_string(atom)
      planet = Enum.find(@gravitysPlanet, fn {_, val} -> val == gravity end) |> elem(0) |> String.capitalize
      "#{string_atom} #{planet}"
    end)
    |> Enum.join(", ")
  end

  def responce(object_info) do
    green() <>
      "#{object_info["mission"]}
      \u2022 path: #{object_info["planets_task"]}
      \u2022 weight of equipment: #{object_info["mass_ship"]}
      \u2022 weight of fuel: #{object_info["weight_of_fuel"]}
      \u2022 arguments: #{object_info["arguments"]}"
    <> reset()
    |> IO.puts
  end

  def getMission(planets_task) do
    case @missions
     |> Enum.find(fn {_, val} -> val == planets_task end)
     |> elem(0) do
       nil -> "Mission not found!"
       item -> item
     end
   end

   def receiveCommand(text) do
     IO.gets(text);
   end
end
