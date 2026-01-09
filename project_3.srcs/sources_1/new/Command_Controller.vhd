----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 06:34:54 PM
-- Design Name: 
-- Module Name: Command_Controller - Behavioral
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

entity Command_Controller is
    Port (command: in std_logic_vector(3 downto 0);
          clock, reset, execute: in std_logic;
          input_select, store_select, enable, memory_toggle: out std_logic;
          counter_select: out std_logic_vector(1 downto 0);
          operation_select: out std_logic_vector(2 downto 0));
end Command_Controller;

architecture Behavioral of Command_Controller is
    type state_type is (idle,
                        add_ui,
                        addwc_ui,
                        save_next, save_next_2,
                        save_ui, save_ui_2,
                        load_ui,
                        load_mem, load_mem_2,
                        add_mem, add_mem_2,
                        addwc_mem, addwc_mem_2);
                        
    signal state_S: state_type;
    
    constant load_counter_sel: Std_logic_vector(1 downto 0) := "10";
    constant hold_counter_sel: Std_logic_vector(1 downto 0) := "00";
    constant inc_counter_sel: Std_logic_vector(1 downto 0) := "01";
    
    constant addwc_in_alu: std_logic_vector(2 downto 0) := "000";
    constant addnc_in_alu: std_logic_vector(2 downto 0) := "001";
    constant XOR_in_alu: std_logic_vector(2 downto 0) := "010";
    constant Hold_in_alu: std_logic_vector(2 downto 0) := "011";
    constant Load_in_alu: std_logic_vector(2 downto 0) := "100";
    
    constant add_ui_cmd: std_logic_vector(3 downto 0) := "0001";
    constant addwc_ui_cmd: std_logic_vector(3 downto 0) := "1001";
    constant save_next_cmd: std_logic_vector(3 downto 0) := "1100";
    constant save_ui_cmd: std_logic_vector(3 downto 0) := "0100";
    constant load_ui_cmd: std_logic_vector(3 downto 0) := "0010";
    constant load_mem_cmd: std_logic_vector(3 downto 0) := "1010";
    constant add_mem_cmd: std_logic_vector(3 downto 0) := "0110";
    constant addwc_mem_cmd: std_logic_vector(3 downto 0) := "1110";
begin
        process(clock, reset, state_S)
            begin   
                if reset = '1' then 
                    state_S <= idle;
                    input_select <= '0';
                    store_select <= '0';
                    enable <= '1';
                    memory_toggle <= '0';
                    counter_select <= load_counter_sel;
                    operation_select <= Hold_in_alu;
                elsif rising_edge(clock) then
                    input_select <= '0';
                    store_select <= '0';
                    enable <= '1';
                    memory_toggle <= '0';
                    counter_select <= load_counter_sel;
                    operation_select <= Hold_in_alu;                    
                    case state_S is
                        when idle =>
                            if execute = '1' then
                                case command is
                                    when add_ui_cmd =>
                                        state_S <= add_ui;
                                    when addwc_ui_cmd =>
                                        state_S <= addwc_ui;
                                    when save_next_cmd =>
                                        state_S <= save_next;
                                    when save_ui_cmd =>
                                        state_S <= save_ui;
                                    when load_ui_cmd =>
                                        state_S <= load_ui;
                                    when load_mem_cmd =>
                                        state_S <= load_mem;
                                    when add_mem_cmd =>
                                        state_S <= add_mem;
                                    when addwc_mem_cmd =>
                                        state_S <= addwc_mem;
                                    when others =>
                                        state_S <= idle;
                                end case;
                            else
                                state_S <= idle;
                            end if;
                        when add_ui =>
                            operation_select <= addnc_in_alu;
                            state_S <= idle;
                        when addwc_ui =>
                            operation_select <= addwc_in_alu;
                            state_S <= idle;
                        when save_next =>
                            memory_toggle <= '1';
                            store_select <= '0';
                            state_S <= save_next_2;
                        when save_next_2 =>
                            counter_select <= inc_counter_sel;
                            state_S <= idle;
                        when save_ui =>
                            memory_toggle <= '1';
                            state_S <= save_ui_2;
                        when save_ui_2 =>
                            store_select <= '1';
                            state_S <= idle;
                        when load_ui =>
                            operation_select <= Load_in_alu;
                            state_S <= idle;
                        when load_mem =>
                            store_select <= '1';
                            memory_toggle <= '0';
                            state_S <= load_mem_2;
                        when load_mem_2 =>
                            input_select <= '1';
                            operation_select <= Load_in_alu;
                            state_S <= idle;
                        when add_mem =>
                            store_select <= '1';
                            memory_toggle <= '0';
                            state_S <= add_mem_2;
                        when add_mem_2 =>
                            input_select <= '1';
                            operation_select <= addnc_in_alu;
                            state_S <= idle;
                        when addwc_mem =>
                            store_select <= '1';
                            memory_toggle <= '0';
                            state_S <= addwc_mem_2; 
                        when addwc_mem_2 =>
                            input_select <= '1';
                            operation_select <= addwc_in_alu;
                            state_S <= idle;
                        when others =>
                            state_S <= idle;
                    end case;
                end if;
        end process; 
end Behavioral;
