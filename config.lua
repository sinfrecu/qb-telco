Config = Config or {}

Config.CurrentProject = 0
Config.Projects = {
-- Centro de la ciudad, carteld de vinewood
    [1] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "ANT-1-Tablero General",
	--	vector3(765.94, 1273.79, 360.3)
                coords = {x = 765.94, y = 1273.79, z = 360.3, h = 92.5, r = 1.0},
            },
            ["tasks"] = {
                [1] = {
			--vector3(739.39, 1275.95, 360.3)
                    coords = {x = 739.39, y = 1275.95, z = 360.3, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Reiniciar Antena 3",
                    IsBusy = false,
                },
                [2] = {
		    -- vector3(790.6, 1269.98, 360.3)
                    coords = {x = 790.6, y = 1269.98, z = 360.3, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Reiniciar Antena 1",
                    IsBusy = false,
                },
                [3] = {
			---vector3(760.85, 1280.45, 360.3)
                    coords = {x = 760.85, y = 1280.45, z = 360.3, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Reiniciar Antena 2",
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
        --      vector3(-1001.97, 4853.76, 274.61)
                coords = {x = -1001.97, y = 4853.76, z = 274.61, h = 92.5, r = 1.0},
            },
            ["tasks"] = {
                [1] = {
			--vector3(-999.47, 4852.61, 274.61)
                    coords = {x = -999.47, y = 4852.61, z = 274.61, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Cambiar Fusibles",
                    IsBusy = false,
                },
                [2] = {
		    -- vector3(-1006.44, 4846.84, 275.01)
                    coords = {x = -1006.44, y = 4846.84, z = 275.01, h = 11.5, r = 1.0},
                    type = "PickAnim",
                    completed = false,
                    label = "Arreglar Cable",
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
        --      vector3(-2507.9, 3306.33, 91.96)
                coords = {x = -2507.9, y =  3306.33, z = 91.96, h = 92.5, r = 1.0},
            },
            ["tasks"] = {
                [1] = {
                        --vector3(-999.47, 4852.61, 274.61)
			-- vector3(-2503.45, 3303.5, 51.45)
                    coords = {x = -2503.45, y = 3303.5, z = 51.45, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Encender Refrigeracion",
                    IsBusy = false,
                },
                [2] = {
                    -- vector3(-1006.44, 4846.84, 275.01)
		    --vector3(-2508.59, 3301.89, 36.54)
                    coords = {x = -2508.59, y = 3301.89, z = 36.54, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Arreglar Cable",
                    IsBusy = false,
                },

        }
        }
    },


}
