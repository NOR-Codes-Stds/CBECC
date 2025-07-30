# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

def thermal_bridging(arguments)

  thermal_bridging = arguments[:thermal_bridging]
  r_bare = arguments[:r_bare]
  wall_base_cavity_insul = arguments[:wall_base_cavity_insul]
  wall_base_cont_insul = arguments[:wall_base_cont_insul]
  parapet_length = arguments[:parapet_length]
  floor_length = arguments[:floor_length]
  wall_area = arguments[:wall_area]

  if thermal_bridging

    r_pre_ins = wall_base_cont_insul + wall_base_cavity_insul

    r_o = r_bare + r_pre_ins

    u_o = 1/r_o


    if (wall_base_cavity_insul == 0.0)
      # Detail 36 [Ext. R, Psi]
      psi_floor_table = [[0.00,0.289],
             [0.88,0.289],
             [1.76,0.322],
             [2.64,0.322],
             [3.52,0.307],
             [4.40,0.290]]

    else

      # Detail 15 [Ext. R, Psi]
      psi_floor_table = [[0.00,0.376],
             [0.88,0.376],
             [1.76,0.341],
             [2.64,0.326],
             [3.52,0.301],
             [4.40,0.290]]

    end

    # Detail 09 [Ext. R, Psi]
    psi_parapet_table = [[0.00,0.541],
             [0.88,0.541],
             [1.76,0.491],
             [2.64,0.468],
             [3.52,0.460],
             [4.40,0.452]]

    # Interpolate value for floor intersection.
    for i in 1..(psi_floor_table.length - 1)

      r = wall_base_cont_insul
      r_1 = psi_floor_table[i-1][0]
      r_2 = psi_floor_table[i][0]

      psi_1 = psi_floor_table[i-1][1]
      psi_2 = psi_floor_table[i][1]

      if (r >= r_1 && r < r_2)

        psi_floor = (psi_2 - psi_1)/(r_2 - r_1)*(r - r_1) + psi_1
        break

      end

    end

    # if wall R-value is greater than those in table use the corresponding highest psi-value
    if (wall_base_cont_insul > psi_floor_table[psi_floor_table.length - 1][0])
      psi_floor = psi_floor_table[psi_floor_table.length - 1][1]
    end

    # Interpolate value for parapet intersection.
    for i in 1..(psi_parapet_table.length - 1)

      r = wall_base_cont_insul
      r_1 = psi_parapet_table[i-1][0]
      r_2 = psi_parapet_table[i][0]

      psi_1 = psi_parapet_table[i-1][1]
      psi_2 = psi_parapet_table[i][1]

      if (r >= r_1 && r < r_2)

        psi_parapet = (psi_2 - psi_1)/(r_2 - r_1)*(r - r_1) + psi_1
        break

      end

    end

    # if wall R-value is greater than those in table use the corresponding highest psi-value
    if (wall_base_cont_insul > psi_parapet_table[psi_parapet_table.length - 1][0])
      psi_parapet = psi_parapet_table[psi_parapet_table.length - 1][1]
    end

    u_add = (psi_parapet*parapet_length + psi_floor*floor_length)/wall_area

    u_total = u_add + u_o

    r_total = 1/u_total

    r_ins = r_total - r_bare

    if (r_ins < 0.0)

      r_ins = 0.0

    end

    if (r_pre_ins > 0.0)
      r_ratio = r_ins/r_pre_ins
    else
      r_ratio = 1.0
    end

  else

    r_ratio = 1.0

  end

  #puts r_ratio

  return r_ratio

end
