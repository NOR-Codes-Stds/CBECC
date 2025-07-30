# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/units")
require("modelkit/thermalbridging")


module Envelope

  # Wall Types
  WALL_CONCRETE_MW_SOLID_GROUTED = "Concrete MW Solid Grouted"
  WALL_METAL_PANELS = "Metal Panels"
  WALL_STEEL_FRAMING_16IN_ON_CENTER = "Steel Framing at 16 in. on center"
  WALL_WOOD_FRAMING_16IN_ON_CENTER = "Wood Framing at 16 in. on center"
  WALL_CONCRETE_NW_SOLID = "Concrete NW Solid"
  WALL_CONCRETE_MW_PARTIALLY_GROUTED = "Concrete MW Partially Grouted"
  WALL_CONCRETE_STEEL_FRAMING = "Concrete with Steel Framing"
  WALL_CONCRETE_WOOD_FRAMING = "Concrete with Wood Framing"
  WALL_GRANITE_10IN = "Granite 10in"
  WALL_STEEL_FRAMING_24IN_ON_CENTER = "Steel Framing at 24 in. on center"
  WALL_WOOD_FRAMING_24IN_ON_CENTER = "Wood Framing at 24 in. on center"
  WALL_BASE_TYPES = [
    WALL_CONCRETE_MW_SOLID_GROUTED,
    WALL_METAL_PANELS,
    WALL_STEEL_FRAMING_16IN_ON_CENTER,
    WALL_WOOD_FRAMING_16IN_ON_CENTER,
    WALL_CONCRETE_NW_SOLID,
    WALL_CONCRETE_MW_PARTIALLY_GROUTED,
    WALL_CONCRETE_STEEL_FRAMING,
    WALL_CONCRETE_WOOD_FRAMING,
    WALL_GRANITE_10IN,
    WALL_STEEL_FRAMING_24IN_ON_CENTER,
    WALL_WOOD_FRAMING_24IN_ON_CENTER
  ]

  # Roof Types
  ROOF_INSULATION_ENTIRELY_ABOVE_DECK = "Insulation Entirely Above Deck"
  ROOF_METAL = "Metal Roof"
  ROOF_ATTIC_WOOD_JOISTS = "Attic Roof with Wood Joists"
  ROOF_ATTIC_STEEL_JOISTS = "Attic Roof with Steel Joists"
  ROOF_CONCRETE = "Concrete Roof"
  ROOF_BASE_TYPES = [
    ROOF_INSULATION_ENTIRELY_ABOVE_DECK,
    ROOF_METAL,
    ROOF_ATTIC_WOOD_JOISTS,
    ROOF_ATTIC_STEEL_JOISTS,
    ROOF_CONCRETE
  ]

  # Constant Values
  CONVERT_U_VALUES = 5.678263337
  FILM_EXTERIOR_R = 0.12 # From RP 1365
  FILM_INTERIOR_R = 0.12 # From RP 1365
  EXTERIOR_AIR_FILM_U_VALUE = 5.88|'U-IP' # Exterior Air Film (ASHRAE 90.1-2013 Section A9.4.1)
  SEMIEXTERIOR_AIR_FILM_U_VALUE = 2.17|'U-IP' # Semi-Exterior Air Film (ASHRAE 90.1-2013 Section A9.4.1)
  INTERIOR_VERTICAL_AIR_FILM_U_VALUE = 1.47|'U-IP' # Interior Vertical Air Film (ASHRAE 90.1-2013 Section A9.4.1)
  INTERIOR_HORIZONTAL_AIR_FILM_U_VALUE = 1.64|'U-IP' # Interior Horizontal Air Film (ASHRAE 90.1-2013 Section A9.4.1)
  GYPSUM_5IN_U_VALUE = 2.22|'U-IP' # 0.5 in. Gypsum Board (ASHRAE 90.1-2013 Table A9.4.3-1)
  GYPSUM_625IN_U_VALUE = 1.79|'U-IP' # 0.625 in. Gypsum Board (ASHRAE 90.1-2013 Table A9.4.3-1)
  STUCCO_U_VALUE = 12.5|'U-IP' # Stucco (ASHRAE 90.1-2013 Table A9.4.3-1)
  CONCRETE_MW_SOLID_GROUTED_U_VALUE = 1.14|'U-IP' # 8 in. Medium Weight 115 lb/ft^3 Concrete Block Walls: Solid Grouted - No Framing (ASHRAE 90.1-2013 Table A3.1-1)
  CONCRETE_NW_SOLID_U_VALUE = 2.01|'U-IP' # 8 in. Normal Weight 145 lb/ft^3 Solid Concrete Walls - No Framing (ASHRAE 90.1-2013 Table A3.1-1)
  CONCRETE_MW_PARTIALLY_GROUTED_U_VALUE = 0.81|'U-IP' # 8 in. Medium Weight 115 lb/ft^3 Concrete Block Walls: Partially Grouted - No Framing (ASHRAE 90.1-2013 Table A3.1-1)
  GRANITE_U_VALUE = 2.98|'U-IP' # Granite 10in (2013 ASHRAE Handbook - Fundamentals Section 26 Table 1 - Calcitic, dolomitic, limestone, marble, and granite - 180 lb/ft^3)
  CONCRETE_SOLID_U_VALUE = 2.01|'U-IP' # 8 in. Normal Weight 145 lb/ft^3 Solid Concrete (ASHRAE 90.1-2013 Section A5.2)
  FIBERGLASS_BATT_COND_SI = 0.0459  # (W/(m-K)) Fiberglass Batt Insulation @ R-3.14/inch
  EX_POLYSTYRENE_COND_SI = 0.0288 # (W/(m-K)) Extruded/Expanded Polystyrene @ R-5/inch

  def self.wall_insulation(wall_base_type, wall_base_cavity_insul = 0.0, wall_base_cont_insul = 0.0, wall_area = 0.0, floor_length = 0.0, parapet_length = 0.0)

    case wall_base_type
    when WALL_CONCRETE_MW_SOLID_GROUTED
    # Mass Wall, 1 in. Metal Clips at 24 in. on Center Horizontally and 16 in. Vertically (ASHRAE 90.1-2007 IP Edition Table A3.1A)
      value = wall_base_cont_insul * CONVERT_U_VALUES
      labels = [0.0, 3.8, 5.7, 7.6, 9.5, 11.4, 13.3, 15.2, 28.0] # Rated R-Value of Insulation Alone
      table = [0.580, 0.195, 0.151, 0.123, 0.104, 0.090, 0.080, 0.071, 0.046] # Assembly U-Factors for 8 in. Medium Weight 115lb/ft3 Concrete Block Walls: Solid Grouted
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + (1 / GYPSUM_5IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cont_insul == 0|'R-IP')
        wall_cont_thick = 0
      elsif (wall_base_cont_insul < 5.7|'R-IP')
        wall_cont_thick = (1.0|'in')
      elsif (wall_base_cont_insul < 7.6|'R-IP')
        wall_cont_thick = (1.5|'in')
      elsif (wall_base_cont_insul < 9.5|'R-IP')
        wall_cont_thick = (2.0|'in')
      elsif (wall_base_cont_insul < 11.4|'R-IP')
        wall_cont_thick = (2.5|'in')
      elsif (wall_base_cont_insul < 13.3|'R-IP')
        wall_cont_thick = (3.0|'in')
      elsif (wall_base_cont_insul < 15.2|'R-IP')
        wall_cont_thick = (3.5|'in')
      elsif (wall_base_cont_insul < 28.0|'R-IP')
        wall_cont_thick = (4.0|'in')
      elsif (wall_base_cont_insul >= 28.0|'R-IP')
        wall_cont_thick = (5.0|'in')
      end
      if (wall_base_cont_insul > 0|'R-IP')
        wall_cont_cond = wall_cont_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cont_cond = FIBERGLASS_BATT_COND_SI
      end
      wall_cav_thick = 0
      wall_cav_cond = FIBERGLASS_BATT_COND_SI

    when WALL_METAL_PANELS
    # Metal Wall, Single Layer of Mineral Fiber Plus Continuous Insulation (ASHRAE 90.1-2007 IP Edition Table A3.2)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 6.0, 10.0, 11.0, 13.0, 16.0, 19.0, 23.0, 26.0, 32.0] # Total Rated R-Value of Insulation
      table = [1.180, 0.184, 0.134, 0.123, 0.113, 0.093, 0.084, 0.061, 0.057, 0.048] # Overall U-Factor for Entire Base Wall Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_thick = (4.0|'in')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
        wall_cav_thick = (0.0|'in')
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_STEEL_FRAMING_16IN_ON_CENTER
    # Steel-Frame, Standard Framing, 16" OC (ASHRAE 90.1-2007 IP Edition Table A3.3)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 11.0, 13.0, 15.0, 19.0, 21.0] # Cavity Insulation R-Value: Rated
      table = [0.352, 0.132, 0.124, 0.118, 0.109, 0.106] # Overall U-Factor for Entire Base Wall Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / STUCCO_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + 0.099 + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul == 0|'R-IP')
        wall_cav_thick = 0
      elsif (wall_base_cavity_insul <= 15|'R-IP')
        wall_cav_thick = (3.5|'in')
      elsif (wall_base_cavity_insul > 15|'R-IP')
        wall_cav_thick = (6.0|'in')
      end
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_WOOD_FRAMING_16IN_ON_CENTER
    # Wood-Frame, Standard Framing, 16" OC (ASHRAE 90.1-2007 IP Edition Table A3.4)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 11.0, 13.0, 15.0, 19.0, 21.0] # Cavity Insulation R-Value: Rated
      table = [0.292, 0.096, 0.089, 0.083, 0.067, 0.063] # Overall U-Factor for Entire Base Wall Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / STUCCO_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + 0.099 + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul == 0|'R-IP')
        wall_cav_thick = 0
      elsif (wall_base_cavity_insul <= 15|'R-IP')
        wall_cav_thick = (3.5|'in')
      elsif (wall_base_cavity_insul > 15|'R-IP')
        wall_cav_thick = (6.0|'in')
      end
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_CONCRETE_NW_SOLID
    # Mass Wall, 1 in. Metal Clips at 24 in. on Center Horizontally and 16 in. Vertically (ASHRAE 90.1-2007 IP Edition Table A3.1A)
      value = wall_base_cont_insul * CONVERT_U_VALUES
      labels = [0.0, 3.8, 5.7, 7.6, 9.5, 11.4, 13.3, 15.2, 28.0] # Rated R-Value of Insulation Alone
      table = [0.740, 0.210, 0.160, 0.129, 0.109, 0.094, 0.082, 0.073, 0.046] # Assembly U-Factors for 8 in. Normal Weight 145lb/ft3 Solid Concrete Walls
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / CONCRETE_NW_SOLID_U_VALUE) + (1 / GYPSUM_5IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + (1 / CONCRETE_NW_SOLID_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cont_insul == 0|'R-IP')
        wall_cont_thick = 0
      elsif (wall_base_cont_insul < 5.7|'R-IP')
        wall_cont_thick = (1.0|'in')
      elsif (wall_base_cont_insul > 7.6|'R-IP')
        wall_cont_thick = (1.5|'in')
      elsif (wall_base_cont_insul < 9.5|'R-IP')
        wall_cont_thick = (2.0|'in')
      elsif (wall_base_cont_insul > 11.4|'R-IP')
        wall_cont_thick = (2.5|'in')
      elsif (wall_base_cont_insul < 13.3|'R-IP')
        wall_cont_thick = (3.0|'in')
      elsif (wall_base_cont_insul > 15.2|'R-IP')
        wall_cont_thick = (3.5|'in')
      elsif (wall_base_cont_insul < 28.0|'R-IP')
        wall_cont_thick = (4.0|'in')
      elsif (wall_base_cont_insul >= 28.0|'R-IP')
        wall_cont_thick = (5.0|'in')
      end
      if (wall_base_cont_insul > 0|'R-IP')
        wall_cont_cond = wall_cont_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cont_cond = FIBERGLASS_BATT_COND_SI
      end
      wall_cav_thick = 0
      wall_cav_cond = FIBERGLASS_BATT_COND_SI

    when WALL_CONCRETE_MW_PARTIALLY_GROUTED
    # Mass Wall, 1 in. Metal Clips at 24 in. on Center Horizontally and 16 in. Vertically (ASHRAE 90.1-2007 IP Edition Table A3.1A)
      value = wall_base_cont_insul * CONVERT_U_VALUES
      labels = [0.0, 3.8, 5.7, 7.6, 9.5, 11.4, 13.3, 15.2, 28.0] # Rated R-Value of Insulation Alone
      table = [0.480, 0.182, 0.143, 0.118, 0.101, 0.088, 0.077, 0.070, 0.045] # Assembly U-Factors for 8 in. Medium Weight 115lb/ft3 Concrete Block Walls: Partially Grouted
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / CONCRETE_MW_PARTIALLY_GROUTED_U_VALUE) + (1 / GYPSUM_5IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + (1 / CONCRETE_MW_PARTIALLY_GROUTED_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cont_insul == 0|'R-IP')
        wall_cont_thick = 0
      elsif (wall_base_cont_insul < 5.7|'R-IP')
        wall_cont_thick = (1.0|'in')
      elsif (wall_base_cont_insul > 7.6|'R-IP')
        wall_cont_thick = (1.5|'in')
      elsif (wall_base_cont_insul < 9.5|'R-IP')
        wall_cont_thick = (2.0|'in')
      elsif (wall_base_cont_insul > 11.4|'R-IP')
        wall_cont_thick = (2.5|'in')
      elsif (wall_base_cont_insul < 13.3|'R-IP')
        wall_cont_thick = (3.0|'in')
      elsif (wall_base_cont_insul > 15.2|'R-IP')
        wall_cont_thick = (3.5|'in')
      elsif (wall_base_cont_insul < 28.0|'R-IP')
        wall_cont_thick = (4.0|'in')
      elsif (wall_base_cont_insul >= 28.0|'R-IP')
        wall_cont_thick = (5.0|'in')
      end
      if (wall_base_cont_insul > 0|'R-IP')
        wall_cont_cond = wall_cont_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cont_cond = FIBERGLASS_BATT_COND_SI
      end
      wall_cav_thick = 0
      wall_cav_cond = FIBERGLASS_BATT_COND_SI

    when WALL_CONCRETE_STEEL_FRAMING
    # Mass Wall, Steel Framing 4in. depth (ASHRAE 90.1-2007 IP Edition Table A3.1D)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0] # Rated R-Value of Insulation
      table = [1.2, 1.3, 2.0, 2.6, 3.0, 3.4, 3.7, 4.0, 4.2, 4.5, 4.6, 4.8, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.8, 5.9, 5.9, 6.0, 6.0,] # 4in. Depth, Metal Framing Type
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = (1 / y) * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + (1 / GYPSUM_5IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_thick = (4.0|'in')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
        wall_cav_thick = (0.0|'in')
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_CONCRETE_WOOD_FRAMING
    # Mass Wall, Wood Studs 4in. depth (ASHRAE 90.1-2007 IP Edition Table A3.1D)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0] # Rated R-Value of Insulation
      table = [1.4, 1.6, 2.6, 3.6, 4.5, 5.3, 6.1, 6.9, 7.6, 8.3, 9.0, 9.6, 10.2, 10.8, 11.3, 11.9, 12.4, 12.8, 13.3, 13.7, 14.2, 14.6, 14.9, 15.3, 15.7, 16.0] # 4in. Depth, Wood Framing Type
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = (1 / y) * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + (1 / GYPSUM_5IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + (1 / CONCRETE_MW_SOLID_GROUTED_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_thick = (4.0|'in')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
        wall_cav_thick = (0.0|'in')
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_GRANITE_10IN
      r_bare = FILM_EXTERIOR_R + (1 / GRANITE_U_VALUE) + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio
      wall_cav_thick = 0
      wall_cav_cond = FIBERGLASS_BATT_COND_SI

    when WALL_STEEL_FRAMING_24IN_ON_CENTER
    # Steel-Frame, Advanced Framing, 24" OC (ASHRAE 90.1-2007 IP Edition Table A3.3)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 11.0, 13.0, 15.0, 19.0, 21.0] # Cavity Insulation R-Value: Rated
      table = [0.338, 0.116, 0.108, 0.102, 0.094, 0.090] # Overall U-Factor for Entire Base Wall Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / STUCCO_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + 0.099 + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul == 0|'R-IP')
        wall_cav_thick = 0
      elsif (wall_base_cavity_insul <= 15|'R-IP')
        wall_cav_thick = (3.5|'in')
      elsif (wall_base_cavity_insul > 15|'R-IP')
        wall_cav_thick = (6.0|'in')
      end
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    when WALL_WOOD_FRAMING_24IN_ON_CENTER
    # Wood-Frame, Advanced Framing, 24" OC (ASHRAE 90.1-2007 IP Edition Table A3.4)
      value = wall_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 11.0, 13.0, 15.0, 19.0, 21.0] # Cavity Insulation R-Value: Rated
      table = [0.298, 0.094, 0.086, 0.080, 0.065, 0.060] # Overall U-Factor for Entire Base Wall Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / STUCCO_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      r_bare = FILM_EXTERIOR_R + 0.099 + FILM_INTERIOR_R
      r_ratio = thermal_bridging(:r_bare=>r_bare, :wall_base_cavity_insul=>wall_base_cavity_insul, :wall_base_cont_insul=>wall_base_cont_insul, :parapet_length=>parapet_length, :floor_length=>floor_length, :wall_area=>wall_area)
      if (wall_base_cavity_insul == 0|'R-IP')
        wall_cav_thick = 0
      elsif (wall_base_cavity_insul <= 15|'R-IP')
        wall_cav_thick = (3.5|'in')
      elsif (wall_base_cavity_insul > 15|'R-IP')
        wall_cav_thick = (6.0|'in')
      end
      if (wall_base_cavity_insul > 0|'R-IP')
        wall_cav_cond = wall_cav_thick * base_assembly_insul_u_si / r_ratio
      else
        wall_cav_cond = EX_POLYSTYRENE_COND_SI
      end
      wall_cont_cond = EX_POLYSTYRENE_COND_SI
      wall_cont_thick = wall_cont_cond * wall_base_cont_insul * r_ratio

    else
      puts "Envelope.wall_insulation: Unknown wall base type #{wall_base_type}"
    end

    return wall_cont_thick, wall_cont_cond, wall_cav_thick, wall_cav_cond

  end

  def self.roof_insulation(roof_base_type, roof_base_cavity_insul = 0.0, roof_base_cont_insul = 0.0)

    case roof_base_type
    when ROOF_INSULATION_ENTIRELY_ABOVE_DECK
      roof_cont_cond = EX_POLYSTYRENE_COND_SI
      roof_cont_thick = roof_cont_cond * roof_base_cont_insul
      roof_cav_thick = 0
      roof_cav_cond = FIBERGLASS_BATT_COND_SI

    when ROOF_METAL
    # Metal Building Roof, Standing Seam Roofs with Thermal Space Blocks (ASHRAE 90.1-2007 IP Edition Table A2.3)
      value = roof_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 6.0, 10.0, 11.0, 13.0, 16.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 26.0, 29.0, 30.0, 32.0, 35.0, 38.0] # Total Rated R-Value of Insulation
      table = [1.280, 0.167, 0.097, 0.092, 0.083, 0.072, 0.065, 0.063, 0.061, 0.060, 0.058, 0.057, 0.055, 0.052, 0.051, 0.049, 0.047, 0.046] # Overall U-Factor for Entire Base Roof Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / EXTERIOR_AIR_FILM_U_VALUE) + (1 / INTERIOR_HORIZONTAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      roof_cav_cond = FIBERGLASS_BATT_COND_SI
      roof_cav_thick = roof_cav_cond / base_assembly_insul_u_si
      roof_cont_cond = EX_POLYSTYRENE_COND_SI
      roof_cont_thick = roof_cont_cond * roof_base_cont_insul

    when ROOF_ATTIC_WOOD_JOISTS
    # Wood-Framed Attic, Standard Framing (ASHRAE 90.1-2007 IP Edition Table A2.4)
      value = roof_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 11.0, 13.0, 19.0, 30.0, 38.0, 49.0, 60.0, 71.0, 82.0, 93.0, 104.0, 115.0, 126.0] # Rated R-Value of Insulation Alone
      table = [0.613, 0.091, 0.081, 0.053, 0.034, 0.027, 0.021, 0.017, 0.015, 0.013, 0.011, 0.010, 0.009, 0.008] # Overall U-Factor for Entire Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / SEMIEXTERIOR_AIR_FILM_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      roof_cav_cond = FIBERGLASS_BATT_COND_SI
      roof_cav_thick = roof_cav_cond / base_assembly_insul_u_si
      roof_cont_cond = EX_POLYSTYRENE_COND_SI
      roof_cont_thick = roof_cont_cond * roof_base_cont_insul

    when ROOF_ATTIC_STEEL_JOISTS
    # Steel-Framed Attic, 4 ft. on Center (ASHRAE 90.1-2007 IP Edition Table A2.5)
      value = roof_base_cavity_insul * CONVERT_U_VALUES
      labels = [0.0, 4.0, 5.0, 8.0, 10.0, 11.0, 12.0, 13.0, 15.0, 16.0, 19.0, 20.0, 21.0, 24.0, 25.0, 30.0, 35.0, 38.0, 40.0, 45.0, 50.0, 55.0] # Rated R-Value of Insulation Alone
      table = [1.282, 0.215, 0.179, 0.120, 0.100, 0.093, 0.086, 0.080, 0.072, 0.068, 0.058, 0.056, 0.054, 0.049, 0.048, 0.041, 0.037, 0.035, 0.033, 0.031, 0.028, 0.027] # Overall U-Factor for Entire Assembly
      y = Envelope.interpolate(value, labels, table)
      base_assembly_u_si = y * CONVERT_U_VALUES
      other_assembly_u_si = 1 / ( (1 / SEMIEXTERIOR_AIR_FILM_U_VALUE) + (1 / GYPSUM_625IN_U_VALUE) + (1 / INTERIOR_VERTICAL_AIR_FILM_U_VALUE) )
      base_assembly_insul_u_si = 1 / ( (1 / base_assembly_u_si) - (1 / other_assembly_u_si) )
      roof_cav_cond = FIBERGLASS_BATT_COND_SI
      roof_cav_thick = roof_cav_cond / base_assembly_insul_u_si
      roof_cont_cond = EX_POLYSTYRENE_COND_SI
      roof_cont_thick = roof_cont_cond * roof_base_cont_insul

    when ROOF_CONCRETE
      roof_cont_cond = EX_POLYSTYRENE_COND_SI
      roof_cont_thick = roof_cont_cond * roof_base_cont_insul
      roof_cav_thick = 0
      roof_cav_cond = FIBERGLASS_BATT_COND_SI

    else
      puts "Envelope.roof_insulation: Unknown roof base type #{roof_base_type}"
    end

    return roof_cont_thick, roof_cont_cond, roof_cav_thick, roof_cav_cond

  end

  def self.interpolate(value, labels, table)

    for index in 0...labels.length
      if (labels[index] > value)
        if (index == 0)
          puts "ERROR: value below range, can't extrapolate"
        else
          value1 = index
          value0 = index - 1
          #puts "found value lower #{labels[index - 1]}"
          #puts "found value upper #{labels[index]}"
        end
        break
      end
    end

    if (value1.nil?)
      puts "ERROR: Value above range, can't extrapolate"
    end

    # Interpolate first between two values
    if (labels[value1] - labels[value0]).zero?
      puts "ERROR: Can't divide by zero"
    else
      m = (table[value1] - table[value0]) / (labels[value1] - labels[value0])
    end
    b = table[value0] - m * labels[value0]
    y = m * value + b

    return(y)

  end

end
