# 📡 qb-telco

**Communications Technician job For QB-Core**

![CodeQL](https://github.com/sinfrecu/qb-telco/workflows/CodeQL/badge.svg)

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
- [x] ⚡ FuseBox minigame to PowerOff electricity by [Tinus_NL](https://forum.cfx.re/u/tinus_nl/)
- [X] 🚐 Work car ( request by @nzkfc )
- [X] 🏢 Blip building location ( request by @nzkfc )
- [x] 🐌 Colddown to prevent multispawn vehicle. (30 minutes)

## Wishlist:
- [ ] 📌 Blips's in task's





## Video Demo

- [Demo Beta.4](https://www.youtube.com/watch?v=iIN0YYjy0nE)
- [Demo Beta.0](https://www.youtube.com/watch?v=h1aTCz35XF8)

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

## Add work to city hall

### Step 1

**Edit the file :** `resources/[qb]/qb-cityhall/client/`[main.lua](https://github.com/qbcore-framework/qb-cityhall/blob/main/client/main.lua) and add `"telco",` to list jobs, example of how it should look:

```
local AvailableJobs = {
    "trucker",
    "taxi",
    "tow",
    "reporter",
    "garbage",
    "telco",
}
```

### Step 2

To be able to select the job in the game we must modify the file `resources/[qb]/qb-cityhall/html/`[index.html](https://github.com/qbcore-framework/qb-cityhall/blob/main/html/index.html) and add `<div class="job-page-block" data-job="telco"><p>Telco Engineer</p></div>`  to `class="job-page-blocks`, example of how it should look:


```
                    <div class="job-page-blocks">
                        <div class="job-page-block" data-job="trucker"><p>Trucker</p></div>
                        <div class="job-page-block" data-job="taxi"><p>Taxi</p></div>
                        <div class="job-page-block" data-job="tow"><p>Tow Truck</p></div>
                        <div class="job-page-block" data-job="reporter"><p>News reporter</p></div>
                        <div class="job-page-block" data-job="garbage"><p>Garbage collector</p></div>
                        <div class="job-page-block" data-job="telco"><p>Telco Engineer</p></div>
                    </div>
```


----
## ❤ Based on
qb-builderjob, qb-vineyard, qb-truckerjob

[Qb-core FiveM RP Framework](https://github.com/qbcore-framework)

----
# Fuse Box

[![Qb-telco-demo](https://raw.githubusercontent.com/sinfrecu/public/main/FuseBox.png
)](https://https://forum.cfx.re/t/release-free-esx-esx-technician/)

A special thanks to [Tinus_NL](https://forum.cfx.re/u/tinus_nl/) original author of the [esx_technician](https://forum.cfx.re/t/release-free-esx-esx-technician/) module "fuse box", who authorized the use of the files and part of the code in this module..
