----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 11:48:42 AM
-- Design Name: 
-- Module Name: SM_SIM - Behavioral
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

entity SM_SIM is
--  Port ( );
end SM_SIM;

architecture Behavioral of SM_SIM is
    component Command_Controller is
        Port (command: in std_logic_vector(3 downto 0);
              clock, reset, execute: in std_logic;
              command_out: out std_logic_vector(8 downto 0));
    end component;
    
    signal commandTB: std_logic_vector(3 downto 0) := "0000";
    signal clockTB, resetTB, executeTB: std_logic := '0';
    signal command_outTB: std_logic_vector(8 downto 0);
    
    type arr_cmd is array (0 to 7) of std_logic_vector(3 downto 0);
    constant cmd_arr: arr_cmd := ("0001","1001","1100","0100","0010", "1010", "0110", "1110");
    type arr_start is array (0 to 1) of std_logic;
    constant start_arr: arr_start := ('0', '1');
begin
    clockTB <= not clockTB after 5ns;
    UUT: Command_Controller port map (clock => clockTB,
                                      reset => resetTB,
                                      execute => executeTB,
                                      command => commandTB,
                                      command_out => command_outTB);
    process
        begin
             resetTB <= '1';
             wait for 10ns;
             resetTB <= '0';
             wait for 10ns;
             for jj in 0 to 1 loop
                executeTB <= start_arr(jj);
                for ii in 0 to 7 loop
                    commandTB <= cmd_arr(ii);
                    wait for 5ns;
                end loop;
             end loop;
    end process;
end Behavioral;

