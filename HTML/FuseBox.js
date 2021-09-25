/*
  _____   _                                 _   _   _
 |_   _| (_)  _ __    _   _   ___          | \ | | | |
   | |   | | | '_ \  | | | | / __|         |  \| | | |    
   | |   | | | | | | | |_| | \__ \         | |\  | | |___ 
   |_|   |_| |_| |_|  \__,_| |___/  _____  |_| \_| |_____|
                                   |_____|
*/

$(function () {
    let SwitchStatus = [
        Fuse1 = false,
        Fuse2 = false,
        Fuse3 = false,
        Fuse4 = false,
        Fuse5 = false,
        Fuse6 = false,
        Fuse7 = false,
        Fuse8 = false,
        Fuse9 = false,
        Fuse10 = false,
        Fuse11 = false,
        Fuse12 = false
    ]

    function Visibility(Status) {
        if (Status === true){
            $(".box").show()

            SwitchStatus.forEach(function (CurrentFuse, CurrentIndex) {
                const RandomNumber = Math.floor(Math.random() * 2)

                if (RandomNumber === 1){
                    SwitchStatus[CurrentIndex] = true
                    
                    document.getElementById("Fuse" + (CurrentIndex + 1)).style.marginTop = "10%"
                    document.getElementById("Fuse" + (CurrentIndex + 1)).style.backgroundColor = "rgb(0, 255, 0)"
                } else {
                    SwitchStatus[CurrentIndex] = false

                    document.getElementById("Fuse" + (CurrentIndex + 1)).style.marginTop = "135%"
                    document.getElementById("Fuse" + (CurrentIndex + 1)).style.backgroundColor = "rgb(255, 0, 0)"
                }
            })
        } else {
            $(".box").hide()

            SwitchStatus = [
                Fuse1 = false,
                Fuse2 = false,
                Fuse3 = false,
                Fuse4 = false,
                Fuse5 = false,
                Fuse6 = false,
                Fuse7 = false,
                Fuse8 = false,
                Fuse9 = false,
                Fuse10 = false,
                Fuse11 = false,
                Fuse12 = false
            ]
        }
    }

    Visibility(false)

    window.addEventListener("message", function (EventInfo) {
        const EventData = EventInfo.data

        if (EventData.RequestType == "Visibility"){
            Visibility(EventData.RequestData)
        }
    })

    document.onkeydown = function (KeyData) {
        if (KeyData.which === 27 || KeyData.which === 8) {
            $.post("http://esx_technician/main", JSON.stringify({ReturnType: "EXIT", ReturnData: "-"}))
        }
    }

    $(".fusebutton").click(function () {
        const ClickedFuseid = this.id
        const ClickedFuseArrayId = Number(ClickedFuseid.replace("Fuse", "")) - 1
        
        if (SwitchStatus[ClickedFuseArrayId] === false) {
            SwitchStatus[ClickedFuseArrayId] = true

            document.getElementById(ClickedFuseid).style.marginTop = "10%"
            document.getElementById(ClickedFuseid).style.backgroundColor = "rgb(0, 255, 0)"
        } else {
            SwitchStatus[ClickedFuseArrayId] = false

            document.getElementById(ClickedFuseid).style.marginTop = "135%"
            document.getElementById(ClickedFuseid).style.backgroundColor = "rgb(255, 0, 0)"
        }

        let FoundWrong = false

        SwitchStatus.forEach(function (CurrentFuse, CurrentIndex) {
            if (CurrentFuse === false){
                FoundWrong = true
            }
        })
        
        if (FoundWrong === false){
            $.post("http://esx_technician/main", JSON.stringify({ReturnType: "DONE", ReturnData: "-"}))
        }
    })
})
