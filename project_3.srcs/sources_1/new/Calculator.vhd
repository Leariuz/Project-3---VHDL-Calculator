----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 06:36:41 PM
-- Design Name: 
-- Module Name: Calculator - Behavioral
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

entity Calculator is
    Port (input: in std_logic_vector(7 downto 0);
          clock_C, main_reset, start: in std_logic;
          action, address: in std_logic_vector(3 downto 0);
          result: out std_logic_vector(7 downto 0));
end Calculator;

architecture Behavioral of Calculator is
    component Command_Controller is
        Port (command: in std_logic_vector(3 downto 0);
              clock, reset, execute: in std_logic;
              input_select, store_select, enable, memory_toggle: out std_logic;
              counter_select: out std_logic_vector(1 downto 0);
              operation_select: out std_logic_vector(2 downto 0));
    end component;
    component DataPath is
        Port (input_sel, store_sel, clock, reset, enable, memory_toggle: in std_logic;
              counter_sel: in std_logic_vector(1 downto 0);
              address_in: in std_logic_vector(3 downto 0);
              operation_sel: in std_logic_vector(2 downto 0);
              user_input: in std_logic_vector(7 downto 0);
              data_bus: inout std_logic_vector(7 downto 0);
              address_out: out std_logic_vector(3 downto 0);
              result_b: out std_logic_vector(7 downto 0));
    end component;
    component BlockMem is
        generic (width : integer := 8;
                 addr_n_bits : integer := 4);
        Port (clock : in std_logic;
              addr_in : in std_logic_vector(addr_n_bits-1 downto 0);
              data : inout std_logic_vector(width-1 downto 0) := (OTHERS => 'Z');
              mem_toggle : in std_logic);
    end component;
    component D_flipflop is
        Port (D_in, clock, enable, reset: in std_logic;
              Q_out: out std_logic);
    end component;
    
    signal control_S: std_logic_vector(8 downto 0);
    signal databus_S: std_logic_vector(7 downto 0);
    signal address_S: std_logic_vector(3 downto 0);
    signal start_preS, start_proS, start_S: std_logic;
    signal not_clock: std_logic;
begin
    start_S <= start_preS and not start_proS;
    not_clock <= not clock_C;
    comp0: Command_Controller port map (clock => clock_C,
                                        reset => main_reset,
                                        command => action,
                                        execute => start_S,
                                        input_select => control_S(8),
                                        store_select => control_S(7),
                                        enable => control_S(6),
                                        memory_toggle => control_S(5),
                                        counter_select => control_S(4 downto 3),
                                        operation_select => control_S(2 downto 0));
    comp1: DataPath port map (clock => clock_C,
                              reset => main_reset,
                              user_input => input,
                              address_in => address,
                              input_sel => control_S(8),
                              store_sel => control_S(7),
                              enable => control_S(6),
                              memory_toggle => control_S(5),
                              counter_sel => control_S(4 downto 3),
                              operation_sel => control_S(2 downto 0),
                              data_bus => databus_S,
                              address_out => address_S,
                              result_b => result);
    comp2: BlockMem port map (clock => clock_C,
                              addr_in => address_S,
                              data => databus_S,
                              mem_toggle => control_S(5));
    comp3: D_flipflop port map (D_in => start,
                                enable => '1',
                                reset => main_reset,
                                clock => not_clock,
                                Q_out => start_preS);
    comp4: D_flipflop port map (D_in => start_preS,
                                enable => '1',
                                reset => main_reset,
                                clock => not_clock,
                                Q_out => start_proS);
end Behavioral;
