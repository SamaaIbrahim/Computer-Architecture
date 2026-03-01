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
	reg_test : register_file port map(clk, reg_write, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);
	process
	begin
		reg_write <= '1';
        write_reg <= "00000";
        read_reg1 <= "00000";
        read_reg2 <= "00001";
		write_data <= x"FFFFFFFF";
		wait for 1 ns;

        assert read_data1 = x"FFFFFFFF" report "Read data 1 is incorrect";
        assert read_data2 = x"00000000" report "Read data 2 is incorrect";
		
        write_reg <= "00011";
        read_reg1 <= "00000";
        read_reg2 <= "00011";
        write_data <= x"1FA11111";
		wait for 1 ns;
        
        assert read_data1 = x"FFFFFFFF" report "Read data 1 is incorrect";
        assert read_data2 = x"1FA11111" report "Read data 2 is incorrect";

        reg_write <= '0';
        write_reg <= "11111";
        read_reg1 <= "00011";
        read_reg2 <= "11111";
		write_data <= x"FFFFFFFF";
        wait for 1 ns;
        
        assert read_data1 = x"1FA11111" report "Read data 1 is incorrect";
        assert read_data2 = x"00000000" report "Read data 2 is incorrect";
        
		wait;
	end process;

	process
	begin
		while true loop
			clk <= '1';
			wait for 0.5 ns;
			clk <= '0';
			wait for 0.5 ns;
		end loop;
	end process;
end behavior;
