library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Traffic is
generic(frequency : integer);
port(
    clock       : in std_logic;
    neg_res     : in std_logic; 
    southred    : out std_logic;
    southyellow : out std_logic;
    southgreen  : out std_logic;
    eastred     : out std_logic;
    eastyellow  : out std_logic;
    eastgreen   : out std_logic);
end entity;

architecture abc of Traffic is

    type cur_state is (southnext, startsouth, south, stopsouth,
                        eastnext, starteast, east, stopeast);
    signal state : cur_state;

    signal cntr : integer range 0 to frequency * 60;

begin

    process(clock) is

        procedure change(tos : cur_State;
                              min : integer := 0;
                              sec : integer := 0) is
            variable total   : integer;
            variable cycles  : integer;
        begin
            total := sec + min * 60;
            cycles  := total * frequency -1;
            if cycles = cycles then
                cntr <= 0;
                state <= tos;
            end if;
        end procedure;

    begin
        if rising_edge(clock) then
            if neg_res = '0' then
              
                state   <= southnext;
                cntr <= 0;
                southred  <= '1';
                southyellow <= '0';
                southgreen  <= '0';
                eastred  <= '1';
                eastyellow  <= '0';
                eastgreen   <= '0';

            else
			
                southred    <= '0';
                southyellow <= '0';
                southgreen <= '0';
                eastred  <= '0';
                eastyellow  <= '0';
                eastgreen  <= '0';

                cntr <= cntr + 1;

                case state is

                    -- Red in all directions
                    when southnext =>
                        southred <= '1';
                        eastred  <= '1';
                        change(startsouth, sec => 5);

                    -- Red and yellow in north/south direction
                    when startsouth =>
                        southred   <= '1';
                        southyellow <= '1';
                        eastred     <= '1';
                        change(south, sec => 5);

                    -- Green in north/south direction
                    when south =>
                        southgreen <= '1';
                        eastred   <= '1';
                        change(stopsouth, min => 1);

                    -- Yellow in north/south direction
                    when stopsouth =>
                        southyellow <= '1';
                        eastred  <= '1';
                        change(eastnext, sec => 5);

                    -- Red in all directions
                    when eastnext =>
                        southred <= '1';
                        eastred  <= '1';
                        change(starteast, sec => 5);

                    -- Red and yellow in west/east direction
                    when starteast =>
                        southred <= '1';
                        eastred   <= '1';
                        eastyellow <= '1';
                        change(east, sec => 5);

                    -- Green in west/east direction
                    when east =>
                        southred  <= '1';
                        eastgreen <= '1';
                        change(stopeast, min => 1);

                    -- Yellow in west/east direction
                    when stopeast =>
                        southred   <= '1';
                        eastyellow <= '1';
                        change(southnext, sec => 5);

                end case;

            end if;
        end if;
    end process;

end architecture;