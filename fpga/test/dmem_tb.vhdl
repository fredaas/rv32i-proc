library ieee;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_1164.all;

library riscv;
  use riscv.dmem;
  use riscv.utils.all;
  use riscv.parameters.all;

entity dmem_tb is
end entity dmem_tb;

architecture testbench of dmem_tb is

  signal i_clk          : std_logic := '0';
  signal i_addr, i_data : std_logic_vector(31 downto 0);
  signal i_ben          : std_logic_vector(3 downto 0);
  signal i_rw           : std_logic;
  signal o_data         : std_logic_vector(31 downto 0) := (others => '0');
  signal o_err          : std_logic;
  signal o_ack          : std_logic;

  constant i_clk_period : time := 10 ns;

begin

  dmem_0 : entity dmem
    generic map (
      dmem_size => dmem_size
    )
    port map (
      i_clk  => i_clk,
      i_addr => i_addr,
      i_data => i_data,
      i_ben  => i_ben,
      i_rw   => i_rw,
      o_data => o_data,
      o_ack  => o_err,
      o_err  => o_ack
    );

  i_clk <= not i_clk after i_clk_period / 2;

  stim_0 : process is

    type ram_t is array (natural range <>) of std_logic_vector(31 downto 0);

    constant ram_data : ram_t :=
    (
      x"000000DE",
      x"000000AD",
      x"000000BE",
      x"000000EF",
      x"00000001",
      x"00000002",
      x"00000003",
      x"00000004"
    );

  begin

    -- Write to DRAM
    i_rw   <= '1';
    i_addr <= x"00000000";
    i_data <= ram_data(0);
    i_ben  <= "0001";
    wait for i_clk_period;

    for i in 1 to 6 loop

      i_data <= ram_data(i);
      i_addr <= i_addr + x"00000001";
      wait for i_clk_period;

    end loop;

    ---- Read from DRAM and verify output
    i_rw   <= '0';
    i_addr <= x"00000000";
    wait for i_clk_period;

    for i in 0 to 6 loop

      i_addr <= i_addr + x"00000001";
      assert o_data = ram_data(i)
        report "Invalid READ"
        severity error;
      wait for i_clk_period;

    end loop;

    wait;

  end process stim_0;

end architecture testbench;
