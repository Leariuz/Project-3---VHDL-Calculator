----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 09:17:58 PM
-- Design Name: 
-- Module Name: Calc_SIM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Calc_SIM is
--  Port ( );
end Calc_SIM;

architecture Behavioral of Calc_SIM is
    component Calculator is
        Port (input: in std_logic_vector(7 downto 0);
              clock_C, main_reset, start: in std_logic;
              action, address: in std_logic_vector(3 downto 0);
              result: out std_logic_vector(7 downto 0));
    end component;
    
    signal input: std_logic_vector(7 downto 0) := "00000000";
    signal clock_C, main_reset, start: std_logic := '0';
    signal action, address: std_logic_vector(3 downto 0) := "0000";
    signal result: std_logic_vector(7 downto 0);
    
     type arr_in is array (0 to 3) of std_logic_vector(7 downto 0);
     constant input_arr: arr_in := ("00100011","10010101","11010101","01010111");
     type arr_add is array (0 to 4) of std_logic_vector(3 downto 0);
     constant add_arr: arr_add := ("0000","1001","0010","1011","1111");
     type arr_cmd is array (0 to 7) of std_logic_vector(3 downto 0);
     constant cmd_arr: arr_cmd := ("0010","1100","0001","1010","1110", "0110", "1001", "0100");
     type arr_start is array (0 to 1) of std_logic;
     constant start_arr: arr_start := ('1', '0');
begin
    clock_C <= not clock_C after 5ns;
    UUT: Calculator port map (input => input,
                              clock_C => clock_C,
                              main_reset => main_reset,
                              start => start,
                              action => action,
                              address => address,
                              result => result);
    process
        begin
             main_reset <= '1';
             wait for 5ns;
             main_reset <= '0';
             wait for 5ns;
             for jj in 0 to 1 loop
                start <= start_arr(jj);
                for ii in 0 to 3 loop
                    input <= input_arr(ii);
                    for mm in 0 to 4 loop
                        address <= add_arr(mm);
                        for nn in 0 to 7 loop
                            action <= cmd_arr(nn);
                            wait for 11ns;
                        end loop;
                    end loop;
                end loop;
             end loop;
    end process;
end Behavioral;
