TITLE Channel: I(h)

COMMENT
    Generic hyperpolarization-activated non-specific cation current
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
      

    SUFFIX IH_params
    NONSPECIFIC_CURRENT i
           
        
    RANGE gmax, gion, e
    
    RANGE Xinf, Xtau

    RANGE X_v0, X_k0, X_kt, X_gamma, X_tau0
    
}

PARAMETER { 
      

    gmax = 0.0001 (S/cm2)  ? default value, should be overwritten when conductance placed on cell
    
    e = -30 (mV) ? default value, may be overwritten when conductance placed on cell

    X_v0 = -0.09 : Note units of this will be determined by its usage in the generic functions (V)

    X_k0 = -0.01 : Note units of this will be determined by its usage in the generic functions (V)

    X_kt = 5 : Note units of this will be determined by its usage in the generic functions (1/s)

    X_gamma = 0.8 : Note units of this will be determined by its usage in the generic functions (unitless)

    X_tau0 = 0.001 : Note units of this will be determined by its usage in the generic functions (s)
    
}



ASSIGNED {
      
    v (mV)
    
    i (mA/cm2)
    
    celsius (degC)
    
    gion (S/cm2)
    Xinf
    Xtau (ms)
    
}

BREAKPOINT { 
                        
    SOLVE states METHOD cnexp
         

    gion = gmax*((X)^1)      

    i = gion*(v - e)
            

}



INITIAL {
  
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
    LOCAL  tau, inf, temp_adj_X
        
    TABLE Xinf, Xtau
    DEPEND celsius, X_v0, X_k0, X_kt, X_gamma, X_tau0
    FROM -150 TO 50 WITH 4000
    
    
    UNITSOFF
    temp_adj_X = 1
    
            
                
           

        
    ?      ***  Adding rate equations for gate: X  ***
   
    ? Note: Equation (and all ChannelML file values) in SI Units so need to convert v first...
    
    v = v * 0.0010   ? temporarily set v to units of equation...
   
    tau = 1 / ( (X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))) + X_tau0


	 
    ? Set correct units of tau for NEURON
    tau = tau * 1000 
    
    v = v * 1000   ? reset v
        
    Xtau = tau/temp_adj_X
   
    ? Note: Equation (and all ChannelML file values) in SI Units so need to convert v first...
    
    v = v * 0.0010   ? temporarily set v to units of equation...
    
    inf = ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) / ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))))

    
    v = v * 1000   ? reset v
        
    Xinf = inf
          
       
    
    ?     *** Finished rate equations for gate: X ***
    

         

}


UNITSON


