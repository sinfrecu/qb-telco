Config = Config or {}

Config.CurrentProject = 0
Config.Projects = {
-- Centro de la ciudad, carteld de vinewood
    [1] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "ANT-1-Tablero General",
                coords = vector3(765.94, 1273.79, 360.3),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(739.39, 1275.95, 360.3),
                    label = "Reiniciar Antena 3",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(790.6, 1269.98, 360.3),
                    label = "Reiniciar Antena 1",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(760.85, 1280.45, 360.3),
                    label = "Reininiar Antena 2",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },

	    }
        }
    },
--- Enlace rural
    [2] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "Enlace Rural",
                coords = vector3(-1001.97, 4853.76, 274.61),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(-999.47, 4852.61, 274.61),
                    label = "Cambiar Fusibles",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(-1006.44, 4846.84, 275.01),
                    type = "PickAnim",
                    requiredTool = "electronickit",
                    label = "Arreglar Cable",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },

        }
        }
    },    
-- Aeropuerto
    [3] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "Enlace Rural",
                coords = vector3(-2507.9, 3306.33, 91.96),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(-2503.45, 3303.5, 51.45),
                    label = "Encender Refrigeracion",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(-2508.59, 3301.89, 36.54),
                    label = "Arreglar Cable",
                    type = "TouchAnim",
                    requiredTool = "electronickit",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },

        }
        }
    },


}
