--Made by Mokey--

if SERVER then
    local currentNextRountTime = 0
		util.AddNetworkString("Countdown")
	
    hook.Add("PlayerInitialSpawn", "SendTimer", function( ply )
        net.Start("Countdown")
			net.WriteFloat( currentNextRoundTime || 0 ) --time till next round
        net.Send( ply )
		
    end)
    function StartCountdown( time, func )
	currentNextRoundTime = CurTime() + time
        net.Start("Countdown")
			net.WriteFloat( currentNextRoundTime ) 
        net.Broadcast()
        timer.Simple( time, function()
            func()
        end)
		
    end
    
    function NormalRound()
        StartCountdown( 30 * 60, SpecialRound ) --Timer countdown 
        PrintMessage( HUD_PRINTTALK, "Rampant Time has ended!")
        BroadcastLua("surface.PlaySound(\"sound/endrampant.wav\")")
    end
    
    function SpecialRound()
        StartCountdown( 10 * 60, NormalRound ) --Timer countdown 
        PrintMessage( HUD_PRINTTALK, "Rampant Time has started and will last for 10 minutes!")
        BroadcastLua("surface.PlaySound(\"sound/rampant.wav\")")
    end
    NormalRound()
end
if CLIENT then
    local time = 0
    net.Receive("Countdown", function()
        time = net.ReadFloat()
    end)
    hook.Add("HUDPaint", "Sweg", function()
        draw.DrawText( string.ToMinutesSeconds(time - CurTime()), "TargetID", ScrW() * 0.1, ScrH() * 0.1, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
    end)
end