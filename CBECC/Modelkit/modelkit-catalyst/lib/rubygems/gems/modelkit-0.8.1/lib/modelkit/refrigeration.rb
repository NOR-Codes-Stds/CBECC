# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.


class RefrigerationCase

  attr_accessor :capacity, :latent_heat_ratio, :runtime_fraction, :length, :case_temp, :credit_type
  attr_accessor :fan_power, :light_power, :ash_power, :ash_control, :height, :defrost_power, :defrost_type
  attr_accessor :case_type

  def initialize(refrig_case)
    case refrig_case
    when "MULTIDECK-MEAT-CASE"
      @capacity = 1444 #'W/m'
      @latent_heat_ratio = 0.3
      @runtime_fraction = 0.85
      @length = 3.0 #'m'
      @case_temp = 2.2 #'C'
      @credit_type = "MULTISHELF-VERTICAL"
      @fan_power = 87.6 #'W/m'
      @light_power = 38.7 #'W/m'
      @ash_power = 65.6 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 443 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "OPEN"
    when "OTHER-MULTIDECK-CASE"
      @capacity = 1444 #'W/m'
      @latent_heat_ratio = 0.3
      @runtime_fraction = 0.85
      @length = 3.0 #'m'
      @case_temp = 2.2 #'C'
      @credit_type = "MULTISHELF-VERTICAL"
      @fan_power = 41.0 #'W/m'
      @light_power = 60.0 #'W/m'
      @ash_power = 0 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 0 #'W/m'
      @defrost_type = "OFF-CYCLE"
      @case_type = "OPEN"
    when "MEAT-WALKIN-COOLER"
      @capacity = 385 #'W/m'
      @latent_heat_ratio = 0.1
      @runtime_fraction = 0.4
      @length = 15.2 #'m'
      @case_temp = 2.2 #'C'
      @credit_type = "SINGLESHELF-HORIZONTAL"
      @fan_power = 164 #'W/m'
      @light_power = 1312 #'W/m'
      @ash_power = 0 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 164 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "WALK-IN"
    when "OTHER-WALKIN-COOLER"
      @capacity = 2503 #'W/m'
      @latent_heat_ratio = 0.1
      @runtime_fraction = 0.4
      @length = 99.0 #'m'
      @case_temp = 2.2 #'C'
      @credit_type = "SINGLESHELF-HORIZONTAL"
      @fan_power = 1066 #'W/m'
      @light_power = 8528 #'W/m'
      @ash_power = 0 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 1066 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "WALK-IN"
    when "REACHIN-FREEZER-CASE"
      @capacity = 539 #'W/m'
      @latent_heat_ratio = 0.1
      @runtime_fraction = 0.85
      @length = 3.0 #'m'
      @case_temp = -15 #'C'
      @credit_type = "SINGLESHELF-HORIZONTAL"
      @fan_power = 65.6 #'W/m'
      @light_power = 108.2 #'W/m'
      @ash_power = 232.9 #'W/m'
      @ash_control = "HEAT-BALANCE-METHOD"
      @height = 1.5 #'m'
      @defrost_power = 1312 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "GLASS-DOOR"
    when "OPEN-FREEZER-CASE"
      @capacity = 529 #'W/m'
      @latent_heat_ratio = 0.1
      @runtime_fraction = 0.85
      @length = 3.0 #'m'
      @case_temp = -12.2 #'C'
      @credit_type = "SINGLESHELF-HORIZONTAL"
      @fan_power = 32.8 #'W/m'
      @light_power = 0 #'W/m'
      @ash_power = 78.7 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 1378 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "OPEN"
    when "WALKIN-FREEZER"
      @capacity = 616 #'W/m'
      @latent_heat_ratio = 0.1
      @runtime_fraction = 0.4
      @length = 38.1 #'m'
      @case_temp = -23.3 #'C'
      @credit_type = "SINGLESHELF-HORIZONTAL"
      @fan_power = 105 #'W/m'
      @light_power = 26.2 #'W/m'
      @ash_power = 0 #'W/m'
      @ash_control = "LINEAR"
      @height = 0.0 #'m'
      @defrost_power = 761 #'W/m'
      @defrost_type = "ELECTRIC"
      @case_type = "WALK-IN"
    when "SELF-CONTAINED"
      @capacity = 887 #'W/m'
      @latent_heat_ratio = 0.08
      @runtime_fraction = 0.85
      @length = 8.93 #'m'
      @case_temp = 2.0 #'C'
      @credit_type = "MULTISHELF-VERTICAL"
      @fan_power = 67 #'W/m'
      @light_power = 40 #'W/m'
      @ash_power = 0.0 #'W/m'
      @ash_control = "NONE"
      @height = 0.0 #'m'
      @defrost_power = 0.0 #'W/m'
      @defrost_type = "NONE"
      @case_type = "SELF-CONTAINED"
    end

  end

end



class RefrigerationRack

  attr_accessor :rack_cop, :fan_power

  def initialize(rack_type)
    case rack_type
    when "LOW-TEMP"
      @rack_cop = 1.3
      @fan_power = 4500 #'W'
    when "MED-TEMP"
      @rack_cop = 2.5 #'F'
      @fan_power = 4500 #'W'
    when "SELF-CONTAINED"
      @rack_cop = 3.0 #'F'
      @fan_power = 1000 #'W'
    end

  end

end
