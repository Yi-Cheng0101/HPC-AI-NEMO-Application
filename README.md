# HPC AI NEMO Application

## About HPC-AI competition
Co-organized by the HPC-AI Advisory Council and the Singapore National Supercomputing Center, the 2020 APAC HPC-AI Competition ran from May 20, 2020 through October 15, 2020
## Part 2 – High-Performance Computing – NEMO Climate Simulation Application
* ### Introduction NEMO ( Nucleus for European Modelling of the Ocean )
    NEMO which stands for Nucleus for European Modelling of the Ocean, is a state of-the-art modelling framework for research activities and forecasting services in ocean and climate sciences, developed in a sustainable way by a European consortium. (https://www.nemo-ocean.eu/) 
NEMO is distributed with several reference configurations, allowing both the user to set up a first application and the developer to validate the developments.
![image](https://github.com/Yi-Cheng0101/HPC-AI-NEMO-Application/blob/master/nemo_img_1.png)
* ### Benckmark GYRE
    The GYRE configuration has been built to simulate the seasonal cycle of a double-gyre box model. 
The domain geometry is a closed rectangular basin on the beta-plane centred at sin(30) and rotated by 45, 3180 km long, 2120 km wide and 4 km deep. The domain is bounded by vertical walls and by a flat bottom. The configuration is meant to represent an idealized North Atlantic or North Pacific basin. The circulation is forced by analytical profiles of wind and buoyancy fluxes.
![image](https://github.com/Yi-Cheng0101/HPC-AI-NEMO-Application/blob/master/nemo_img_0.png)
* ### Hotspot Analysis
    * Profiler: vtune
    * __traadv_fct_MOD_tra_adv_fct is the main hotspot
    * ![image]()
* ### Installation

* ### Result

* ### User Guide
