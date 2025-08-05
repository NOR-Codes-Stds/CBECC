# CBECC: California Building Energy Code Compliance Software
CBECC (California Building Energy Code Compliance) for non residential, single family, and multi family is an open source project that may be used by Code Agencies, Rating Authorities, or Utility Programs in the development of energy codes, standards, or efficiency programs. Architects, engineers, and energy consultants may also use these tools to demonstrate compliance with energy codes or beyond-code programs.

The software's key components are:

- **Graphical User Interface (GUI)** - allows users to enter details about a proposed building's design
- **Ruleset** - a computer-processable form of the building energy code
- **Compliance Manager** - the core of CBECC. Uses the ruleset to assess whether the building complies with the energy code.
- **Connection to the U.S. Department of Energy's EnergyPlus Simulation Engine** - performs energy simulations to compare proposed building energy consumption to the energy code "budget"
- **Report Generator** - generates forms and other reports to summarize the building's compliance characteristics. Forms may be submitted for building permits, or as documentation for other programs.
- **Application Programmng Interface (API) Documentation** - The purpose of this document is to provide information needed to develop software interfaces to the CEC Compliance engine DLL(s).

CBECC Version includes the Ruleset for California's 2022 Title 24 Energy Code. CBECC-Com Version includes the Ruleset for California's 2019 Title 24 Energy Code. The Title 24 Ruleset represents the performance approach for compliance as described in the 2022/2019 Nonresidential Alternative Calculation Method (NACM) Reference Manual. It also features an API to allow third party software developers to utilize the functionality of the CBECC-Com Compliance Manager.
