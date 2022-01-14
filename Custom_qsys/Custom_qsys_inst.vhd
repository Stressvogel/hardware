	component Custom_qsys is
		port (
			heartbeat_data_export         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			hrv_clock_clk                 : in    std_logic                     := 'X';             -- clk
			hrv_hex0_readdata             : out   std_logic_vector(6 downto 0);                     -- readdata
			hrv_hex1_readdata             : out   std_logic_vector(6 downto 0);                     -- readdata
			hrv_hex2_readdata             : out   std_logic_vector(6 downto 0);                     -- readdata
			hrv_ledg_writeresponsevalid_n : out   std_logic;                                        -- writeresponsevalid_n
			hrv_ledr_readdata             : out   std_logic_vector(15 downto 0);                    -- readdata
			ps2_CLK                       : inout std_logic                     := 'X';             -- CLK
			ps2_DAT                       : inout std_logic                     := 'X';             -- DAT
			pushbuttons_export            : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			ref_clk_clk                   : in    std_logic                     := 'X';             -- clk
			ref_reset_reset               : in    std_logic                     := 'X';             -- reset
			sdram_addr                    : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                      : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                   : out   std_logic;                                        -- cas_n
			sdram_cke                     : out   std_logic;                                        -- cke
			sdram_cs_n                    : out   std_logic;                                        -- cs_n
			sdram_dq                      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_dqm                     : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_ras_n                   : out   std_logic;                                        -- ras_n
			sdram_we_n                    : out   std_logic;                                        -- we_n
			sdram_clk_clk                 : out   std_logic;                                        -- clk
			sram_DQ                       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_ADDR                     : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_LB_N                     : out   std_logic;                                        -- LB_N
			sram_UB_N                     : out   std_logic;                                        -- UB_N
			sram_CE_N                     : out   std_logic;                                        -- CE_N
			sram_OE_N                     : out   std_logic;                                        -- OE_N
			sram_WE_N                     : out   std_logic;                                        -- WE_N
			vga_CLK                       : out   std_logic;                                        -- CLK
			vga_HS                        : out   std_logic;                                        -- HS
			vga_VS                        : out   std_logic;                                        -- VS
			vga_BLANK                     : out   std_logic;                                        -- BLANK
			vga_SYNC                      : out   std_logic;                                        -- SYNC
			vga_R                         : out   std_logic_vector(7 downto 0);                     -- R
			vga_G                         : out   std_logic_vector(7 downto 0);                     -- G
			vga_B                         : out   std_logic_vector(7 downto 0)                      -- B
		);
	end component Custom_qsys;

	u0 : component Custom_qsys
		port map (
			heartbeat_data_export         => CONNECTED_TO_heartbeat_data_export,         -- heartbeat_data.export
			hrv_clock_clk                 => CONNECTED_TO_hrv_clock_clk,                 --      hrv_clock.clk
			hrv_hex0_readdata             => CONNECTED_TO_hrv_hex0_readdata,             --       hrv_hex0.readdata
			hrv_hex1_readdata             => CONNECTED_TO_hrv_hex1_readdata,             --       hrv_hex1.readdata
			hrv_hex2_readdata             => CONNECTED_TO_hrv_hex2_readdata,             --       hrv_hex2.readdata
			hrv_ledg_writeresponsevalid_n => CONNECTED_TO_hrv_ledg_writeresponsevalid_n, --       hrv_ledg.writeresponsevalid_n
			hrv_ledr_readdata             => CONNECTED_TO_hrv_ledr_readdata,             --       hrv_ledr.readdata
			ps2_CLK                       => CONNECTED_TO_ps2_CLK,                       --            ps2.CLK
			ps2_DAT                       => CONNECTED_TO_ps2_DAT,                       --               .DAT
			pushbuttons_export            => CONNECTED_TO_pushbuttons_export,            --    pushbuttons.export
			ref_clk_clk                   => CONNECTED_TO_ref_clk_clk,                   --        ref_clk.clk
			ref_reset_reset               => CONNECTED_TO_ref_reset_reset,               --      ref_reset.reset
			sdram_addr                    => CONNECTED_TO_sdram_addr,                    --          sdram.addr
			sdram_ba                      => CONNECTED_TO_sdram_ba,                      --               .ba
			sdram_cas_n                   => CONNECTED_TO_sdram_cas_n,                   --               .cas_n
			sdram_cke                     => CONNECTED_TO_sdram_cke,                     --               .cke
			sdram_cs_n                    => CONNECTED_TO_sdram_cs_n,                    --               .cs_n
			sdram_dq                      => CONNECTED_TO_sdram_dq,                      --               .dq
			sdram_dqm                     => CONNECTED_TO_sdram_dqm,                     --               .dqm
			sdram_ras_n                   => CONNECTED_TO_sdram_ras_n,                   --               .ras_n
			sdram_we_n                    => CONNECTED_TO_sdram_we_n,                    --               .we_n
			sdram_clk_clk                 => CONNECTED_TO_sdram_clk_clk,                 --      sdram_clk.clk
			sram_DQ                       => CONNECTED_TO_sram_DQ,                       --           sram.DQ
			sram_ADDR                     => CONNECTED_TO_sram_ADDR,                     --               .ADDR
			sram_LB_N                     => CONNECTED_TO_sram_LB_N,                     --               .LB_N
			sram_UB_N                     => CONNECTED_TO_sram_UB_N,                     --               .UB_N
			sram_CE_N                     => CONNECTED_TO_sram_CE_N,                     --               .CE_N
			sram_OE_N                     => CONNECTED_TO_sram_OE_N,                     --               .OE_N
			sram_WE_N                     => CONNECTED_TO_sram_WE_N,                     --               .WE_N
			vga_CLK                       => CONNECTED_TO_vga_CLK,                       --            vga.CLK
			vga_HS                        => CONNECTED_TO_vga_HS,                        --               .HS
			vga_VS                        => CONNECTED_TO_vga_VS,                        --               .VS
			vga_BLANK                     => CONNECTED_TO_vga_BLANK,                     --               .BLANK
			vga_SYNC                      => CONNECTED_TO_vga_SYNC,                      --               .SYNC
			vga_R                         => CONNECTED_TO_vga_R,                         --               .R
			vga_G                         => CONNECTED_TO_vga_G,                         --               .G
			vga_B                         => CONNECTED_TO_vga_B                          --               .B
		);

