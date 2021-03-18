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

function PassiveUpdate()
    local message, err, part = sock:receive("*all")
    if not message then message = part end
    if message and string.len(message) > 0 then
        -- print(message)
        local a, b, c, d = loadstring('return ' .. message)()
        -- print(res)
        if a ~= null and b ~= null and c ~= null and d ~= null then
            --     sock:send("r"..a.."g"..b.."b"..c.."p"..d)
            --      sock:send(a)
            sock:send(a .. " " .. b .. " " .. c .. " " .. d)

        elseif a ~= nil then
            if type(a) == "boolean" then
                if a then
                    sock:send("true")
                else
                    sock:send("false")
                end
            elseif type(a) == "function" or type(a) == "table" then
                sock:send(tostring(a))
            else
                sock:send(a)

            end
        end

    end
end

function memory.readbyteppu(a)
    memory.writebyte(0x2001, 0x00) -- Turn off rendering
    memory.readbyte(0x2002) -- PPUSTATUS (reset address latch)
    memory.writebyte(0x2006, math.floor(a / 0x100)) -- PPUADDR high byte
    memory.writebyte(0x2006, a % 0x100) -- PPUADDR low byte
    if a < 0x3f00 then
        dummy = memory.readbyte(0x2007) -- PPUDATA (discard contents of internal buffer if not reading palette area)
    end
    ret = memory.readbyte(0x2007) -- PPUDATA
    memory.writebyte(0x2001, 0x1e) -- Turn on rendering
    return ret
end

function memory.readbytesppu(a, l)
    memory.writebyte(0x2001, 0x00) -- Turn off rendering
    local ret
    local i
    ret = ""
    for i = 0, l - 1 do
        memory.readbyte(0x2002) -- PPUSTATUS (reset address latch)
        memory.writebyte(0x2006, math.floor((a + i) / 0x100)) -- PPUADDR high byte
        memory.writebyte(0x2006, (a + i) % 0x100) -- PPUADDR low byte
        if (a + i) < 0x3f00 then
            dummy = memory.readbyte(0x2007) -- PPUDATA (discard contents of internal buffer if not reading palette area)
        end
        ret = ret .. string.char(memory.readbyte(0x2007)) -- PPUDATA
    end
    memory.writebyte(0x2001, 0x1e) -- Turn on rendering
    return ret
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

function testkb(a)
    if a == 7 then
        sock:send(a + 3)
    else
        sock:send(123)
    end
end

function iamgroot() gui.text(50, 50, "i am groot", "white", "black") end

function PerFunc(rec)
    if rec ~= nil then
        loadstring('return ' .. rec)()
        perVar = rec
    end
end

perVar = nil

function main()
    local address = "127.0.0.1"
    local port = 30000
    local waitTime = 10

    isClientStarted = StartClient(address, port, waitTime)

    if isClientStarted then gui.register(PassiveUpdate) end

    while isClientStarted do
        if pcall(PassiveUpdate) then
        else
            print("null")
        end
        PerFunc(perVar)
        emu.frameadvance()
    end
end

main()
