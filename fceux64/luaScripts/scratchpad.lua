-- Important functions for SMB game

function GetScore()
    local score = memory.readbyterange(2014, 6)
    sock:send(score)

  --  scoreVal = (string.byte(score, 1) * 10 ^ 5) +
  --  (string.byte(score, 2) * 10 ^ 4) +
  --  (string.byte(score, 3) * 10 ^ 3) +
  --  (string.byte(score, 4) * 10 ^ 2) +
  --  (string.byte(score, 5) * 10 ^ 1) +
  --  string.byte(score, 6)
end

function GetPos()
  -- position
  local a = memory.readbyte(109,1)
  local b = memory.readbyte(134,1)
  local pos = (a*256)+b
  sock:send(pos)  
end


function TogglePause()
  -- Pause Game (Don't pause emulator, otherwise everything works but screen updates only when emu is unpaused)
  joypad.set(1, {
      A = false,
      up = false,
      left = false,
      B = false,
      select = false,
      right = false,
      down = false,
      start = true
  })
end

function SensorError()
  print "Sensor Error"
  -- Clear Bar 
  memory.writebyterangeppu(0x23C2, "\234\170\170\170")
  memory.writebyterangeppu(0x2008,
                           "\36\36\36\36\36\36\36\36\36\36\36\36\36\36\36\36")
  -- Write WAIT
  memory.writebyteppu(0x23C0, 0xAF)
  memory.writebyterangeppu(0x2000, "\32\10\18\29")
end

function ResumeFromError()
  print "Resume From Error"
  -- Show Bar 
  memory.writebyterangeppu(0x23C2, "\224\160\160\160")
  memory.writebyterangeppu(0x2008,
                           "\39\39\39\39\39\39\39\39\39\39\39\39\39\39\39\39")
  -- Clear WAIT
  memory.writebyteppu(0x23C0, 0xAA)
  memory.writebyterangeppu(0x2000, "\36\36\36\36")

end

function Beat()
  memory.writebyteppu(0x23C1, 0xA6)
  memory.writebyteppu(0x2007, 0xCE)
end

function NoBeat()
  memory.writebyteppu(0x23C1, 0xAA)
  memory.writebyteppu(0x2007, 0x24)
end

