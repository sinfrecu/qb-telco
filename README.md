# 📡 qb-telco

**Communications Technician job For QB-Core**

## Todo:

- [x] 💰Pay 
- [x] 💲Bonus pay 
- [x] 🔍Job requierd "telco"
- [x] 📍blit and update blit
- [x] 🔨Requierd tool's on inventory
- [x] 🔩Consume metals ,
- [x] coords to vector3
- [x] Requeriments Tool and Materials **per task** , all on config.lua

Whislist:
- [ ] ⚡Power system, use BuilderData.ShowDetails, to turn off the antenna before working, if you work without displaying "ShowDetails" you can be electrocuted by a random, (add Tazzer animation )
- [ ] 📌blit's in task's


## Add job to Qb-core (⭐Required)

**Edit the file :** `/resources/[qb]/qb-core/shared.lua` and add job in `QBShared.Jobs = {`

```
	["telco"] = {
		label = "Technician",
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Communications",
                payment = 50
            },
        },
        },
```



----

❤ Based on qb-builderjob, qb-vineyard, qb-truckerjob

[Qb-core FiveM RP Framework](https://github.com/qbcore-framework)

