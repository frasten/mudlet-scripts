if tick == nil then
	tick = {
		durata = 75,
		avviso = 5,
		time = 0,
		id = nil
	}

	-- Inizializziamo il tick
	tick.id = createStopWatch()
end

-- Mettiamo la label
local width, height = getMainWindowSize();
createLabel( "lblTick", width-20, height-16, 20, 13, 0)
moveWindow("lblTick", width-20, height-16)
showWindow("lblTick");


function resetTick()
	resetStopWatch(tick.id)
	startStopWatch(tick.id)

	-- A quanto pare:
	-- If you disable a timer and then enable it again, its clock is reset.
	-- quindi posso sincronizzare il refresh grafico del tick con quello del mud.
	disableTimer("graphicalTickTimer")
	enableTimer("graphicalTickTimer")

end


-- funzione utile, incredibile che non esista in LUA.
if (math.round == nil) then
	function math.round(num, decimals)
		local shift = 10 ^ decimals
		local result = math.floor(num*shift + 0.5 ) / shift
		return result
	end
end




function tickRefresh()
	-- Refresh del tick
	local secondi = math.round(tonumber(getStopWatchTime(tick.id)),0)
	secondi = tick.durata - secondi


	if secondi == tick.avviso then
		setFgColor( 0, 255, 255 )
		echo("TICK IN " .. tick.avviso .. " SECONDS\n")
		resetFormat()
	elseif secondi <= 0 then
		resetTick()
	end

	-- Non mi piace che allo scadere del tick mostri 0. Voglio ancora il massimo.
	if secondi == 0 then
		secondi = tick.durata
	end

	tick.time = secondi

	-- Mostriamolo colorato!
	if secondi <= tick.avviso then
		secondi = "<span style='color: red'>" .. secondi .. "</span>"
	else
		secondi = "<span style='color: white'>" .. secondi .. "</span>"
	end
	echo("lblTick", secondi)
end
