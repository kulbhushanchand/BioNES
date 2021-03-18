local socket = require("socket.core")

function connect(address, port, laddress, lport)
    local sock, err = socket.tcp()
    if not sock then return nil, err end
    if laddress then
        local res, err = sock:bind(laddress, lport, -1)
        if not res then return nil, err end
    end
    local res, err = sock:connect(address, port)
    if not res then return nil, err end
    return sock
end

function bind(host, port, backlog)
    local sock, err = socket.tcp()
    if not sock then return nil, err end
    sock:setoption("reuseaddr", true)
    local res, err = sock:bind(host, port)
    if not res then return nil, err end
    res, err = sock:listen(backlog)
    if not res then return nil, err end
    return sock
end

function StartClient(address, port, waitTime)

    local timeRef = os.clock()

    print("Connecting to server " .. address .. ":" .. port .. "   ......")
    print("If server is not started, then start it within" .. waitTime ..
              " seconds")
    print("Emulation is paused while looking for server")
    while sock == nil and (os.clock() - timeRef) < waitTime do
        sock, err = connect(address, port)
    end
    if sock then
        sock:settimeout(0)
        print("Connected", sock, err)
        return true
    elseif sock == nil then
        print("Server not found ! Please restart the lua script")
        return false
    end

end

function memory.writebyteppu(a, v)
    memory.writebyte(0x2001, 0x00) -- Turn off rendering
    memory.readbyte(0x2002) -- PPUSTATUS (reset address latch)

    --   memory.writebyte(0x2006, 0x23)
    --   memory.writebyte(0x2006, 0xC2)
    --   memory.writebyte(0x2007, 0x16)

    memory.writebyte(0x2006, math.floor(a / 0x100)) -- PPUADDR high byte
    memory.writebyte(0x2006, a % 0x100) -- PPUADDR low byte
    memory.writebyte(0x2007, v) -- PPUDATA
    memory.writebyte(0x2001, 0x1e) -- Turn on rendering
end

function memory.writebyterangeppu(a, str)
    memory.writebyte(0x2001, 0x00) -- Turn off rendering

    local i
    for i = 0, #str - 1 do
        memory.readbyte(0x2002) -- PPUSTATUS (reset address latch)
        memory.writebyte(0x2006, math.floor((a + i) / 0x100)) -- PPUADDR high byte
        memory.writebyte(0x2006, (a + i) % 0x100) -- PPUADDR low byte
        memory.writebyte(0x2007, string.byte(str, i + 1)) -- PPUDATA
    end

    memory.writebyte(0x2001, 0x1e) -- Turn on rendering
end

function PassiveUpdate()
    local message, err, part = sock:receive(1)
    if not message then message = part end

    if message and string.len(message) > 0 then
        -- print(message)
        local func = c_tbl[string.byte(message)]
        if (func) then
            func()
        else
            print " Unknown command"
        end

    end
end

function Debug()
    print "Debug"
    memory.writebyteppu(0x23C0, 0xE4)
    memory.writebyterangeppu(0x2000, "\36\37\36\37")
    memory.writebyterangeppu(0x2020, "\38\39\38\39")
    memory.writebyterangeppu(0x2040, "\36\37\36\37")
    memory.writebyterangeppu(0x2060, "\38\39\38\39")
end

function SetBar0()
    print "Bar 0"
    memory.writebyterangeppu(0x23C2, "\239\175\175\175")
    memory.writebyterangeppu(0x2008,
                             "\37\37\37\37\37\37\37\37\37\37\37\37\37\37\37\37")
end

function SetBar1()
    print "Bar 1"
    memory.writebyterangeppu(0x23C2, "\235\170\170\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\37\37\37\37\37\37\37\37\37\37\37\37\37\37")
end

function SetBar2()
    print "Bar 2"
    --    memory.writebyterangeppu(0x23C2, "\239\160\160\160")
    --    memory.writebyterangeppu(0x2008, "\38\38\38\38\39\39\39\39\39\39\39\39\39\39\39\39")
    memory.writebyterangeppu(0x23C2, "\239\170\170\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\37\37\37\37\37\37\37\37\37\37\37\37")
end

function SetBar3()
    print "Bar 3"
    memory.writebyterangeppu(0x23C2, "\239\171\170\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\37\37\37\37\37\37\37\37\37\37")
end

function SetBar4()
    print "Bar 4"
    memory.writebyterangeppu(0x23C2, "\224\160\170\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\38\38\37\37\37\37\37\37\37\37")
end

function SetBar5()
    print "Bar 5"
    memory.writebyterangeppu(0x23C2, "\224\160\168\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\38\38\38\38\37\37\37\37\37\37")
end

function SetBar6()
    print "Bar 6"
    memory.writebyterangeppu(0x23C2, "\224\160\160\170")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\38\38\38\38\38\38\37\37\37\37")
end

function SetBar7()
    print "Bar 7"
    memory.writebyterangeppu(0x23C2, "\224\160\160\168")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\38\38\38\38\38\38\38\38\37\37")
end

function SetBar8()
    print "Bar 8"
    memory.writebyterangeppu(0x23C2, "\224\160\160\160")
    memory.writebyterangeppu(0x2008,
                             "\38\38\38\38\38\38\38\38\38\38\38\38\38\38\38\38")
end


function GetData()
    
    local ps = memory.readbyte(14,1) -- player state
    local screen = memory.readbyte(1827,1) -- 0 when player in main screen, 1 otherwise
    -- position
    local a = memory.readbyte(109,1)
    local b = memory.readbyte(134,1)
    local pos = (a*256)+b

    -- score
    local score = memory.readbyterange(2014, 6)

    -- compile and send data packet
    dataPacket = ps .. ','.. screen .. ',' .. pos .. ',' .. score

    print(dataPacket)
    sock:send(dataPacket)  
end

function SetTimerZero()
    memory.writebyte(2040, 0)
    memory.writebyte(2041, 0)
    memory.writebyte(2042, 0)

end



function main()
    local address = "127.0.0.1"
    local port = 30000
    local waitTime = 10

    c_tbl = {
        [0] = SetBar0,
        [1] = SetBar1,
        [2] = SetBar2,
        [3] = SetBar3,
        [4] = SetBar4,
        [5] = SetBar5,
        [6] = SetBar6,
        [7] = SetBar7,
        [8] = SetBar8,
        [9] = GetData,
        [10] = SetTimerZero,
        [11] = Debug

    }

    isClientStarted = StartClient(address, port, waitTime)
    if isClientStarted then gui.register(PassiveUpdate) end

    while isClientStarted do
        if pcall(PassiveUpdate) then
        else
            print("null")
        end
        --  PerFunc(perVar)
        emu.frameadvance()
    end
end

main()
