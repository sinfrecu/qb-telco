# 📡 qb-telco

**Communications Technician job For QB-Core**

## Todo:

- [x] 💰Pay 
- [x] 💲Bonus pay 
- [x] 🔍Job Required "telco"
- [x] 📍Blip and Update Blip
- [x] 🔨Required tool's on Inventory
- [x] 🔩Consume metals ,
- [x] coords to vector3
- [x] Requirements Tool and Materials **per task** , all on config.lua

Wishlist:
- [ ] ⚡Power system, use BuilderData.ShowDetails, to turn off the antenna before working, if you work without displaying "ShowDetails" you can be electrocuted by a random, (add Tazzer animation )
- [ ] 📌Blips's in task's


## Video Demo

[![Qb-telco-demo](https://raw.githubusercontent.com/sinfrecu/public/main/qb-telco-00.png
)](https://www.youtube.com/watch?v=h1aTCz35XF8)

[Ver en Youtube](https://www.youtube.com/watch?v=h1aTCz35XF8)

## Add job to Qb-core (⭐Required)

**Edit the file :** `/resources/[qb]/qb-core/shared.lua` and add the job in `QBShared.Jobs = {`

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

