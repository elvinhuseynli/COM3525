library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TrafficSimulator is
end entity;

architecture abm of TrafficSimulator is

    constant frequency : integer := 100;
    constant period    : time    := 1000 ms / frequency;

    signal clock         : std_logic := '1';
    signal neg_res       : std_logic := '0';
    signal southred    : std_logic;
    signal southyellow : std_logic;
    signal sorthgreen  : std_logic;
    signal eastred     : std_logic;
    signal eastyellow  : std_logic;
    signal eastgreen   : std_logic;

begin

    tr_lights : entity work.Traffic(abc)
    generic map(frequency => frequency)
    port map(clock         => clock,
             neg_res       => neg_res,
             southred    => southred,
             southyellow => southyellow,
             southgreen  => sorthgreen,
             eastred    => eastred,
             eastyellow  => eastyellow,
             eastgreen   => eastgreen);

    clock <= not clock after period / 2;

    process is
    begin
        wait until rising_edge(clock);
        wait until rising_edge(clock);

        neg_res <= '1';

        wait;
    end process;

end architecture;