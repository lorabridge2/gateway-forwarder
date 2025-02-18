import gpiod
import time

chip = gpiod.Chip("/dev/gpiochip0")
out = gpiod.LineSettings(direction=gpiod.line.Direction.OUTPUT)
a = chip.request_lines({23: out})
time.sleep(1)
a.set_value(23, gpiod.line.Value.ACTIVE)
time.sleep(1)
a.set_value(23, gpiod.line.Value.INACTIVE)
time.sleep(1)
a.reconfigure_lines({23: gpiod.LineSettings(direction=gpiod.line.Direction.INPUT)})
time.sleep(1)
a.release()
chip.close()
