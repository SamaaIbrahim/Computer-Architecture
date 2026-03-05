library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity tb_register_file is
end tb_register_file;

architecture behavior of tb_register_file is
component register_file is
    Port (
        clk       : in  std_logic;
        reg_write : in  std_logic;
        read_reg1 : in  std_logic_vector(4 downto 0);
        read_reg2 : in  std_logic_vector(4 downto 0);
        write_reg : in  std_logic_vector(4 downto 0);
        write_data: in  std_logic_vector(31 downto 0);
        read_data1: out std_logic_vector(31 downto 0);
        read_data2: out std_logic_vector(31 downto 0)
    );
end component;

signal clk: std_logic := '1';
signal reg_write: std_logic := '0';
signal read_reg1, read_reg2, write_reg: std_logic_vector(4 downto 0) := (others => '0');
signal write_data: std_logic_vector(31 downto 0) := (others => '0');
signal read_data1, read_data2: std_logic_vector(31 downto 0) := (others => '0');

begin
	reg_test : register_file port map(
        clk, 
        reg_write, 
        read_reg1, 
        read_reg2, 
        write_reg, 
        write_data, 
        read_data1, 
        read_data2
    );
	
    process
	begin
		while true loop
			clk <= '1';
			wait for 100 ps;
			clk <= '0';
			wait for 100 ps;
		end loop;
	end process;
    
    process
    begin
        reg_write <= '1';

        -- CASE1: Write R1, read R1 and R0
        write_reg <= "00001";
        write_data <= x"11111111";
        read_reg1 <= "00001";
        read_reg2 <= "00000";
        wait for 200 ps;
        assert read_data1 = x"11111111" report "CASE1 failed: R1 read-after-write incorrect";
        assert read_data2 = x"00000000" report "CASE1 failed: R0 must be zero";

        -- CASE2: Write R2, read R2 and R1
        write_reg <= "00010";
        write_data <= x"22222222";
        read_reg1 <= "00010";
        read_reg2 <= "00001";
        wait for 200 ps;
        assert read_data1 = x"22222222" report "CASE2 failed: R2 read-after-write incorrect";
        assert read_data2 = x"11111111" report "CASE2 failed: R1 should remain previous value";

    	-- Writing is disabled
		reg_write <= '0';

        -- CASE3: attempt write R3 (ignored)
        write_reg <= "00011";
        write_data <= x"33333333";
        read_reg1 <= "00011";
        read_reg2 <= "00010";
        wait for 200 ps;
        assert read_data1 = x"00000000" report "CASE3 failed: R3 must not change";
        assert read_data2 = x"22222222" report "CASE3 failed: R2 must remain unchanged";

        -- CASE4: reg_write = 0, attempt write R1 (ignored)
        write_reg <= "00001";
        write_data <= x"44444444";
        read_reg1 <= "00001";
        read_reg2 <= "00010";
        wait for 200 ps;
        assert read_data1 = x"11111111" report "CASE4 failed: R1 must remain unchanged";
        assert read_data2 = x"22222222" report "CASE4 failed: R2 must remain unchanged";

        wait;
    end process;

end behavior;
