library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions

-- Combines NIOS II processor with custom VHDL components
entity top_level is
    port (
        CLOCK_50, CLOCK2_50, CLOCK3_50 : in std_logic;
        VGA_R, VGA_G, VGA_B: out std_logic_vector(7 downto 0);
        VGA_CLK: inout std_logic;
        VGA_BLANK_N: inout std_logic;
        VGA_SYNC_N: inout std_logic;
        VGA_HS: inout std_logic;
        VGA_VS: out std_logic;
        PS2_KBCLK: inout std_logic;
        PS2_KBDAT: inout std_logic;
        PS2_MSCLK: inout std_logic;
        PS2_MSDAT: inout std_logic;
        KEY: in std_logic_vector(3 downto 0);
        SRAM_DQ: inout std_logic_vector(15 downto 0);
        SRAM_UB_N: out std_logic;
        SRAM_LB_N: out std_logic;
        SRAM_CE_N: out std_logic;
        SRAM_OE_N: out std_logic;
        SRAM_WE_N: out std_logic;
        SRAM_ADDR: out std_logic_vector(19 downto 0);
        GPIO: inout std_logic_vector(35 downto 0);
        DRAM_ADDR: out std_logic_vector(12 downto 0);
        DRAM_BA: out std_logic_vector(1 downto 0);
        DRAM_CAS_N: out std_logic;
        DRAM_CKE: out std_logic;
        DRAM_CS_N: out std_logic;
        DRAM_DQ: inout std_logic_vector(31 downto 0);
        DRAM_DQM: out std_logic_vector(3 downto 0);
        DRAM_RAS_N: out std_logic;
        DRAM_WE_N: out std_logic;
        DRAM_CLK: out std_logic
    );
end top_level;


architecture top_level_arc of top_level is

	 
	component i2c_master IS
	  GENERIC(
		 input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
		 bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
	  PORT(
		 clk       : IN     STD_LOGIC;                    --system clock
		 reset_n   : IN     STD_LOGIC;                    --active low reset
		 ena       : IN     STD_LOGIC;                    --latch in command
		 addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
		 rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
		 data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
		 busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
		 data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
		 ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
		 sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
		 scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
	END component;
	
	component MAX30102_driver IS
	  PORT(
		 clk       : IN     STD_LOGIC;                    		--system clock
		 reset_n   : IN     STD_LOGIC;                    		--active low reset
		 ena       : OUT     STD_LOGIC;                    	--latch in command
		 addr      : OUT     STD_LOGIC_VECTOR(6 DOWNTO 0); 	--address of target slave
		 rw        : OUT     STD_LOGIC;                    	--'0' is write, '1' is read
		 data_wr   : OUT     STD_LOGIC_VECTOR(7 DOWNTO 0); 	--data to write to slave
		 busy      : IN    STD_LOGIC;                    		--indicates transaction in progress
		 data_rd   : IN    STD_LOGIC_VECTOR(7 DOWNTO 0); 		--data read from slave
		 data_sample : out std_logic_vector(15 downto 0)		-- heartrate data
		 );
	END component;

   component Custom_qsys is
		port (
			heartbeat_data_export : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			hrv_clock_export      : in    std_logic                     := 'X';             -- export
			ps2_CLK               : inout std_logic                     := 'X';             -- CLK
			ps2_DAT               : inout std_logic                     := 'X';             -- DAT
			pushbuttons_export    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			ref_clk_clk           : in    std_logic                     := 'X';             -- clk
			ref_reset_reset       : in    std_logic                     := 'X';             -- reset
			sdram_addr            : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba              : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n           : out   std_logic;                                        -- cas_n
			sdram_cke             : out   std_logic;                                        -- cke
			sdram_cs_n            : out   std_logic;                                        -- cs_n
			sdram_dq              : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_dqm             : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_ras_n           : out   std_logic;                                        -- ras_n
			sdram_we_n            : out   std_logic;                                        -- we_n
			sdram_clk_clk         : out   std_logic;                                        -- clk
			sram_DQ               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_ADDR             : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_LB_N             : out   std_logic;                                        -- LB_N
			sram_UB_N             : out   std_logic;                                        -- UB_N
			sram_CE_N             : out   std_logic;                                        -- CE_N
			sram_OE_N             : out   std_logic;                                        -- OE_N
			sram_WE_N             : out   std_logic;                                        -- WE_N
			vga_CLK               : out   std_logic;                                        -- CLK
			vga_HS                : out   std_logic;                                        -- HS
			vga_VS                : out   std_logic;                                        -- VS
			vga_BLANK             : out   std_logic;                                        -- BLANK
			vga_SYNC              : out   std_logic;                                        -- SYNC
			vga_R                 : out   std_logic_vector(7 downto 0);                     -- R
			vga_G                 : out   std_logic_vector(7 downto 0);                     -- G
			vga_B                 : out   std_logic_vector(7 downto 0)                      -- B
		);
	end component Custom_qsys;

	signal reset : std_logic;
	 
	-- signals for communication between MAX30102_driver and I2C Master
	signal i2c_ena : std_logic;
	signal i2c_addr : std_logic_vector(6 downto 0);
	signal i2c_rw : std_logic;
	signal i2c_data_wr : std_logic_vector(7 downto 0);
	signal i2c_busy : std_logic;
	signal i2c_data_rd : std_logic_vector(7 downto 0);
	 
	 signal heartbeat_data_sig : std_logic_vector(15 downto 0);
begin
    reset <= KEY(2);

    u0 : component Custom_qsys
        port map (
            ref_clk_clk         => CLOCK_50,     --   ref_clk.clk
            ref_reset_reset     => reset, -- ref_reset.reset
            sdram_addr          => DRAM_ADDR,      --     sdram.addr
            sdram_ba            => DRAM_BA,        --          .ba
            sdram_cas_n         => DRAM_CAS_N,     --          .cas_n
            sdram_cke           => DRAM_CKE,       --          .cke
            sdram_cs_n          => DRAM_CS_N,      --          .cs_n
            sdram_dq            => DRAM_DQ,        --          .dq
            sdram_dqm           => DRAM_DQM,       --          .dqm
            sdram_ras_n         => DRAM_RAS_N,     --          .ras_n
            sdram_we_n          => DRAM_WE_N,      --          .we_n
            sdram_clk_clk       => DRAM_CLK,    -- sdram_clk.clk
            sram_DQ             => SRAM_DQ,         --      sram.DQ
            sram_ADDR           => SRAM_ADDR,       --          .ADDR
            sram_LB_N           => SRAM_LB_N,       --          .LB_N
            sram_UB_N           => SRAM_UB_N,       --          .UB_N
            sram_CE_N           => SRAM_CE_N,       --          .CE_N
            sram_OE_N           => SRAM_OE_N,       --          .OE_N
            sram_WE_N           => SRAM_WE_N,       --          .WE_N
            vga_CLK             => VGA_CLK,         --       vga.CLK
            vga_HS              => VGA_HS,          --          .HS
            vga_VS              => VGA_VS,          --          .VS
            vga_BLANK           => VGA_BLANK_N,       --          .BLANK
            vga_SYNC            => VGA_SYNC_N,        --          .SYNC
            vga_R               => VGA_R,           --          .R
            vga_G               => VGA_G,           --          .G
            vga_B               => VGA_B,            --          .B
            pushbuttons_export  => KEY,             -- pushbuttons.export
            ps2_CLK             => PS2_KBCLK,            --         ps2.CLK
            ps2_DAT             => PS2_KBDAT,             --            .DAT
            heartbeat_data_export                => heartbeat_data_sig,                --     hrv_i2c.export
				hrv_clock_export => CLOCK_50
        );

		  
	i2c : i2c_master port map (clk => CLOCK_50, 
										reset_n => KEY(2), 
										ena => i2c_ena, 
										addr => i2c_addr, 
										rw => i2c_rw, 
										data_wr => i2c_data_wr, 
										busy => i2c_busy, 
										data_rd => i2c_data_rd, 
										sda => GPIO(0), 
										scl => GPIO(1)
										);
										
	driver : MAX30102_driver port map (clk => CLOCK_50,
														reset_n => KEY(2),
														ena => i2c_ena, 
														addr => i2c_addr, 
														rw => i2c_rw, 
														data_wr => i2c_data_wr,
														busy => i2c_busy,
														data_rd => i2c_data_rd,
														data_sample => heartbeat_data_sig
														);
end top_level_arc;
