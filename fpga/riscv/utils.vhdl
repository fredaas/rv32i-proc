library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_textio.all;

library std;
  use std.textio.all;

library riscv;
  use riscv.parameters.all;

----------------------------------------------------------------------------------------------------
----------------------                      Declarations                      ----------------------
----------------------------------------------------------------------------------------------------

package utils is

  type mem8_t is array (natural range <>) of std_logic_vector(7 downto 0);

  impure function load_sw_binary
  return mem8_t;

end package utils;

----------------------------------------------------------------------------------------------------
----------------------                       Definitions                      ----------------------
----------------------------------------------------------------------------------------------------

package body utils is

  impure function load_sw_binary
  return mem8_t is

    file     fh  : text;
    variable lr  : line;
    variable ram : mem8_t(0 to 1024 - 1); -- FIXME: Change this to something not hardcoded

  begin

    file_open(fh, code_bin_path, read_mode);

    for i in ram'range loop

      readline(fh, lr);
      read(lr, ram(i));

    end loop;

    return ram;

  end function load_sw_binary;

end package body utils;
