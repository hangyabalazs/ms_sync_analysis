COMMENT

ENDCOMMENT


?  This is a NEURON mod file generated from a ChannelML file

?  Unit system of original ChannelML file: SI Units

COMMENT
    ChannelML file containing a single Channel description
ENDCOMMENT

TITLE Channel: Na_fast_ub

COMMENT
    Na channel for septal neurons
ENDCOMMENT


UNITS {
    (mA) = (milliamp)
    (mV) = (millivolt)
    (S) = (siemens)
    (um) = (micrometer)
    (molar) = (1/liter)
    (mM) = (millimolar)
    (l) = (liter)
}


    
NEURON {
      

    SUFFIX Na_fast_ub
    USEION na READ ena WRITE ina VALENCE 1  ? reversal potential of ion is read, outgoing current is written
           
        
    RANGE gmax, gion
    
    RANGE Xinf, Xtau
    RANGE Yinf, Ytau
    
}

PARAMETER { 
      

    gmax = 0.0500 (S/cm2)  ? default value, should be overwritten when conductance placed on cell
    
}



ASSIGNED {
      

    v (mV)
    
    celsius (degC)
          

    ? Reversal potential of Na
    ena (mV)
    ? The inward flow of ion: Na calculated by rate equations...
    ina (mA/cm2)
    
    
    gion (S/cm2)
    Xinf
    Xtau (ms)
    Yinf
    Ytau (ms)
    
}

BREAKPOINT { 
                        
    SOLVE states METHOD cnexp
         
    X = Xinf

    gion = gmax*((X)^3)*(Y)     

    ina = gion*(v - ena)
            

}



INITIAL {
    
    ena = 55
        
    rates(v)
    X = Xinf
    Y = Yinf
        
    
}
    
STATE {
    X
    Y
    
}

DERIVATIVE states {
    rates(v)
    Y' = (Yinf - Y)/Ytau
    
}

PROCEDURE rates(v(mV)) {  
    
    ? Note: not all of these may be used, depending on the form of rate equations
    LOCAL  alpha, beta, tau, inf, gamma, zeta, temp_adj_X, temp_adj_Y, A_alpha_X, B_alpha_X, Vhalf_alpha_X, A_beta_X, B_beta_X, Vhalf_beta_X, C_alpha_X, A_alpha_Y, B_alpha_Y, Vhalf_alpha_Y, A_beta_Y, B_beta_Y, Vhalf_beta_Y
        
    TABLE Xinf, Xtau, Yinf, Ytau
 DEPEND celsius
 FROM -100 TO 50 WITH 3000
    
    
    UNITSOFF
    temp_adj_X = 1
    temp_adj_Y = 10
            
                
           

        
    ?      ***  Adding rate equations for gate: X  ***
        
    ? Found a parameterised form of rate equation for alpha, using expression: -C*(v-Vhalf)/exp(-A*(v-Vhalf)-1)
    A_alpha_X = 100
    C_alpha_X = 100
    Vhalf_alpha_X = -0.033
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_alpha_X = A_alpha_X * 0.0010   ? 1/mV
    C_alpha_X = C_alpha_X * 0.0010   ? 1/ms
    Vhalf_alpha_X = Vhalf_alpha_X * 1000   ? mV
          
                     
    alpha = -C_alpha_X *(v - Vhalf_alpha_X) / (exp( - A_alpha_X* (v - Vhalf_alpha_X)) - 1)
    
    
    ? Found a parameterised form of rate equation for beta, using expression: A*exp((v-Vhalf)/B)
    A_beta_X = 4000
    B_beta_X = -0.018
    Vhalf_beta_X = -0.058   
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_beta_X = A_beta_X * 0.0010   ? 1/ms
    B_beta_X = B_beta_X * 1000   ? mV
    Vhalf_beta_X = Vhalf_beta_X * 1000   ? mV
          
                     
    beta = A_beta_X * exp((v - Vhalf_beta_X) / B_beta_X)
    
    Xtau = 1/(temp_adj_X*(alpha + beta))
    Xinf = alpha/(alpha + beta)
          
    
    ?     *** Finished rate equations for gate: X ***
    




        
    ?      ***  Adding rate equations for gate: Y  ***
        
    ? Found a parameterised form of rate equation for alpha, using expression: A*exp((v-Vhalf)/B)
    A_alpha_Y = 70
    B_alpha_Y = -0.01
    Vhalf_alpha_Y = -0.051
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_alpha_Y = A_alpha_Y * 0.0010   ? 1/ms
    B_alpha_Y = B_alpha_Y * 1000   ? mV
    Vhalf_alpha_Y = Vhalf_alpha_Y * 1000   ? mV
          
    alpha = A_alpha_Y * exp((v - Vhalf_alpha_Y) / B_alpha_Y)
    
    
    ? Found a parameterised form of rate equation for beta, using expression: B/(exp(-A*(v+Vhalf)+1))
    A_beta_Y = 100
    B_beta_Y = 1000
    Vhalf_beta_Y = -0.021   
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_beta_Y = A_beta_Y * 0.0010   ? 1/mV
    B_beta_Y = B_beta_Y / 1000   ? 1/ms
    Vhalf_beta_Y = Vhalf_beta_Y * 1000   ? mV
          
                     
    beta = B_beta_Y / (exp(-A_beta_Y * (v - Vhalf_beta_Y)) + 1)
    
    Ytau = 1/(temp_adj_Y*(alpha + beta))
    Yinf = alpha/(alpha + beta)
          
    
    ?     *** Finished rate equations for gate: Y ***
    

}


UNITSON


