# Impedance_Admittance_Bus_creator
## Impedance and Admittance matrix creator (Electrical power system) based on MATLAB App Designer
This is a MATLAB based project which can be used to create Impedance or Admittance matrix using custom bus data.

Developed on **MATLAB R2020a** <br />
Created by **Sneh Kothari**

### Results:

#### GIF output of app

![Output sample](https://github.com/snehkothari28/Impedance_Admittance_Bus_creator/blob/master/example.gif)


## Contents:

This repo contains following files:
#### main.m 
The main file to run the app <br />

#### matrixappdialog.m
The new window dialog app which is called by 'main.m' file. This shouldn't be executed directly. <br />

#### zbus.m 
This function calculates the impedance bus matrix when appropriate input bus data is passed. <br />
Seperate subfunctions for modification and kron algorithm is defined. <br />

#### ybus.m
This function calculates the admittance bus matrix when appropriate input bus data is passed. <br />

#### example.gif 
The sample gif of output <br />

## Instructions:

1. Download all the files in one folder <br />
2. Run the main.m to run the app.
