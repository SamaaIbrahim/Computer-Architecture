library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity register_file is
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
end register_file;

ARCHITECTURE reg_behavior OF register_file IS

    type reg_file is array(0 to 31) of std_logic_vector(31 downto 0);
    SIGNAL reg: reg_file := (others => (others => '0'));
    signal temp1, temp2: std_logic_vector(31 downto 0) := (others => '0');
	
BEGIN
	
    process(clk)
	BEGIN
		if(reg_write = '1' AND falling_edge(clk)) then
			reg(to_integer(unsigned(write_reg))) <= write_data;
        end if;
	END PROCESS;
    
    read_data1 <= reg(to_integer(unsigned(read_reg1)));
    read_data2 <= reg(to_integer(unsigned(read_reg2)));

END reg_behavior;
