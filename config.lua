Config = Config or {}

Config.CurrentProject = 0

Config.BailPrice = 250
Config.Vehicle = "UtilliTruck"

Config.JobLocations = {
    ["npc"] = {
        label = "Cheef",
        coords = vector3(528.55, -1594.02, 29.31),
    },
    ["vehicle"] = {
        label = "[E] vehicle job",
        coords = vector4(525.27, -1600.91, 29.2, 225.05),
    },
}


Config.Projects = {
-- Spanish: Centro de la ciudad, carteld de vinewood
-- English: Downtown Vinewood
    [1] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "VIW-0 Cell Tower",
                coords = vector3(765.94, 1273.79, 360.3),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(739.39, 1275.95, 360.3),
                    label = "Change transformer",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(790.6, 1269.98, 360.3),
                    label = "Replace contactors",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "aluminum",
                    requiredItemAmount = 2,
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(760.85, 1280.45, 360.3),
                    label = "Update circuit",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "electronickit",
                    requiredItemAmount = 1,
                    completed = false,
                    IsBusy = false,
                },

	    }
        }
    },
--- Spanish: Enlace rural
--- English: Rural Link
    [2] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "RSC-P Rural Small Cell",
                coords = vector3(-1001.97, 4853.76, 274.61),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(-999.47, 4852.61, 274.61),
                    label = "Change circuit breaker",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "plastic",
                    requiredItemAmount = 1,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(-1006.44, 4846.84, 275.01),
                    label = "Repair cable",
                    type = "PickAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "copper",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(-1003.11, 4845.9, 278.84),
                    label = "Repair plate",
                    type = "TouchLight",
                    requiredTool = "screwdriverset",
                    requiredItem = "aluminum",
                    requiredItemAmount = 3,
                    completed = false,
                    IsBusy = false,
                },
        }
        }
    },    
-- Spanish: Aeropuerto
-- English: Airport
    [3] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "ARB-A Airport Base",
                coords = vector3(-2513.13, 3299.53, 32.92),
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(-2503.42, 3303.5, 51.45),
                    label = "Change circuit breaker",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "copper",
                    requiredItemAmount = 2,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(-2499.85, 3305.51, 36.54),
                    label = "Clean air filter AC1",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "cleaningkit",
                    requiredItemAmount = 1,
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(-2501.53, 3302.66, 36.54),
                    label = "Clean air filter AC2",
                    type = "TouchAnim",
                    requiredTool = "screwdriverset",
                    requiredItem = "cleaningkit",
                    requiredItemAmount = 1,
                    completed = false,
                    IsBusy = false,
                },

        }
        }
    },
-- Tatoo Sandy Shores (small tower)
    [4] = {
    IsActive = false,
    ProjectLocations = {
        ["main"] = {
            label = "SAND-I Transmitter Station",
            coords = vector3(1872.09, 3711.83, 33.08),
        },
        ["tasks"] = {
            [1] = {
                coords = vector3(1867.56, 3711.77, 33.07),
                label = "Repair Fire Alarm",
                type = "TouchAnim",
                requiredTool = "screwdriverset",
                requiredItem = "electronickit",
                requiredItemAmount = 2,
                completed = false,
                IsBusy = false,
            },
            [2] = {
                coords = vector3(1868.98, 3709.9, 33.32),
                label = "Clean air filter",
                type = "TouchUp",
                requiredTool = "screwdriverset",
                requiredItem = "cleaningkit",
                requiredItemAmount = 1,
                completed = false,
                IsBusy = false,
            },
            [3] = {
                coords = vector3(1865.89, 3716.54, 33.07),
                label = "Repair Vandalism",
                type = "TouchLight",
                requiredTool = "screwdriverset",
                requiredItem = "plastic",
                requiredItemAmount = 4,
                completed = false,
                IsBusy = false,
            },

    }
    }
    },
}
