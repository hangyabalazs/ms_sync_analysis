COMMENT
changed from kd (Golomb model).
ENDCOMMENT

NEURON {
  SUFFIX kd_new
  USEION k READ ek WRITE ik
  RANGE gkd, g, tau_a, tau_b
}

UNITS {
  (S) = (siemens)
  (mV) = (millivolt)
  (mA) = (milliamp)
}

PARAMETER {
  gkd = 0.00039 (S/cm2)
  theta_a = -50 (mV)
  sigma_a = 20 (mV)
  theta_b = -60 (mV)
  sigma_b = -6 (mV)
  tau_a = 2 (ms)
  tau_b = 150 (ms)
}

ASSIGNED {
  v (mV)
  ek (mV)
  ik (mA/cm2)
  g (S/cm2)
}

STATE {a b}

BREAKPOINT {
  SOLVE states METHOD cnexp
  g = gkd * a^3 * b
  ik = g * (v-ek)
}

INITIAL {
  a = ainfi(v)
  b = binfi(v)
}

DERIVATIVE states {
  a' = (ainfi(v)-a)/tau_a
  b' = (binfi(v)-b)/tau_b
}

FUNCTION ainfi(v (mV)) {
  UNITSOFF
  ainfi=1/(1 + exp(-(v-theta_a)/sigma_a))
  UNITSON
}

FUNCTION binfi(v (mV)) {
  UNITSOFF
  binfi=1/(1 + exp(-(v-theta_b)/sigma_b))
  UNITSON
}
