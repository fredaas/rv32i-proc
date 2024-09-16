library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_textio.all;

library std;
  use std.textio.all;

library riscv;
  use riscv.utils.all;
  use riscv.parameters.all;

entity dmem is
  generic (
    dmem_size : natural
  );
  port (
    i_clk  : in    std_logic;
    i_addr : in    std_logic_vector(31 downto 0); -- Access address
    i_data : in    std_logic_vector(31 downto 0); -- Write data
    i_ben  : in    std_logic_vector(3 downto 0);  -- Byte enable
    i_rw   : in    std_logic;                     -- 0 = read, 1 = write
    o_data : out   std_logic_vector(31 downto 0); -- Read data, valid if ack = 1
    o_ack  : out   std_logic;                     -- Set when data is valid
    o_err  : out   std_logic                      -- Set if access error
  );
end entity dmem;

architecture dmem_rtl of dmem is

  signal data : std_logic_vector(31 downto 0) := x"00000000";

  signal mem_ram_b0, mem_ram_b1, mem_ram_b2, mem_ram_b3 : mem8_t(0 to (dmem_size / 4) - 1) := (others => x"00");

begin

  mem_read : process (i_clk) is
  begin

    if (rising_edge(i_clk)) then
      if (i_rw = '1') then
        if (i_ben(0) = '1') then -- Byte 0
          mem_ram_b0(to_integer(unsigned(i_addr))) <= i_data(7 downto 0);
        end if;
        if (i_ben(1) = '1') then -- Byte 1
          mem_ram_b1(to_integer(unsigned(i_addr))) <= i_data(15 downto 8);
        end if;
        if (i_ben(2) = '1') then -- Byte 2
          mem_ram_b2(to_integer(unsigned(i_addr))) <= i_data(23 downto 16);
        end if;
        if (i_ben(3) = '1') then -- Byte 3
          mem_ram_b3(to_integer(unsigned(i_addr))) <= i_data(31 downto 24);
        end if;
      end if;
      data(7  downto 0)  <= mem_ram_b0(to_integer(unsigned(i_addr)));
      data(15 downto 8)  <= mem_ram_b1(to_integer(unsigned(i_addr)));
      data(23 downto 16) <= mem_ram_b2(to_integer(unsigned(i_addr)));
      data(31 downto 24) <= mem_ram_b3(to_integer(unsigned(i_addr)));
    end if;

  end process;

  o_data <= data when (i_rw = '0') else (others => '0');
  o_err  <= '0';
  o_ack  <= '0';

end architecture dmem_rtl;
