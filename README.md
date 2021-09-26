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
- [x] ⚡Power system, use BuilderData.ShowDetails, to turn off the antenna before working, if you work without displaying "ShowDetails" you can be electrocuted by a random, (add Tazzer animation )
- [x] ⚡ FuseBox minigame to PowerOff electricity


Wishlist:

- [ ] 📌 Blips's in task's
- [ ] 🏢 building location ( by @nzkfc )
- [ ] 🚐 Work car ( by @nzkfc )



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
## ❤ Based on
qb-builderjob, qb-vineyard, qb-truckerjob

[Qb-core FiveM RP Framework](https://github.com/qbcore-framework)

----
# Fuse Box

[![Qb-telco-demo](https://raw.githubusercontent.com/sinfrecu/public/main/FuseBox.png
)](https://https://forum.cfx.re/t/release-free-esx-esx-technician/)

A special thanks to [Tinus_NL](https://forum.cfx.re/u/tinus_nl/) original author of the [esx_technician](https://forum.cfx.re/t/release-free-esx-esx-technician/) module "fuse box", who authorized the use of the files and part of the code in this module.
