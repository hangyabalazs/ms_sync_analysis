COMMENT

ENDCOMMENT


?  This is a NEURON mod file generated from a ChannelML file

?  Unit system of original ChannelML file: SI Units

COMMENT
    ChannelML file containing a single Channel description
ENDCOMMENT

TITLE Channel: K_fast_ub

COMMENT
    K channel for septal neurons
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
      

    SUFFIX K_fast_ub
    USEION k READ ek WRITE ik VALENCE 1  ? reversal potential of ion is read, outgoing current is written
           
        
    RANGE gmax, gion
    
    RANGE Xinf, Xtau
    
}

PARAMETER { 
      

    gmax = 0.0080 (S/cm2)  ? default value, should be overwritten when conductance placed on cell
    
}



ASSIGNED {
      

    v (mV)
    
    celsius (degC)
          

    ? Reversal potential of k
    ek (mV)
    ? The outward flow of ion: k calculated by rate equations...
    ik (mA/cm2)
    
    
    gion (S/cm2)
    Xinf
    Xtau (ms)
    
}

BREAKPOINT { 
                        
    SOLVE states METHOD cnexp
         

    gion = gmax*((X)^4)      

    ik = gion*(v - ek)
            

}



INITIAL {
    
    ek = -85
        
    rates(v)
    X = Xinf
        
    
}
    
STATE {
    X
    
}

DERIVATIVE states {
    rates(v)
    X' = (Xinf - X)/Xtau
    
}

PROCEDURE rates(v(mV)) {  
    
    ? Note: not all of these may be used, depending on the form of rate equations
    LOCAL  alpha, beta, tau, inf, gamma, zeta, temp_adj_X, A_alpha_X, B_alpha_X, Vhalf_alpha_X, A_beta_X, B_beta_X, Vhalf_beta_X, C_alpha_X
        
    TABLE Xinf, Xtau
 DEPEND celsius
 FROM -100 TO 50 WITH 3000
    
    
    UNITSOFF
    temp_adj_X = 10
    
            
                
           

        
    ?      ***  Adding rate equations for gate: X  ***
        
    ? Found a parameterised form of rate equation for alpha, using expression: -C*(v-Vhalf)/exp(-A*(v-Vhalf)-1)
    A_alpha_X = 100
    C_alpha_X = 10
    Vhalf_alpha_X = -0.038
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_alpha_X = A_alpha_X * 0.0010   ? 1/ms
    C_alpha_X = C_alpha_X * 0.0010   ? 1/ms
    Vhalf_alpha_X = Vhalf_alpha_X * 1000   ? mV
          
                     
    alpha = -C_alpha_X *(v - Vhalf_alpha_X) / (exp( - A_alpha_X* (v - Vhalf_alpha_X)) - 1)
    
    
    ? Found a parameterised form of rate equation for beta, using expression: A*exp((v-Vhalf)/B)
    A_beta_X = 125
    B_beta_X = -0.08
    Vhalf_beta_X = -0.048   
    
    ? Unit system in ChannelML file is SI units, therefore need to convert these to NEURON quanities...
    
    A_beta_X = A_beta_X * 0.0010   ? 1/ms
    B_beta_X = B_beta_X * 1000   ? mV
    Vhalf_beta_X = Vhalf_beta_X * 1000   ? mV
          
                     
    beta = A_beta_X * exp((v - Vhalf_beta_X) / B_beta_X)
    
    Xtau = 1/(temp_adj_X*(alpha + beta))
    Xinf = alpha/(alpha + beta)
          
       
    
    ?     *** Finished rate equations for gate: X ***
    

         

}


UNITSON


