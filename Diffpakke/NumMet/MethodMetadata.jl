order(::FEuler) = 1
name(::FEuler) = "Forward Euler"

order(::Heun) = 2
name(::Heun) = "Heun's Method"

order(::MidpointRK2) = 2
name(::MidpointRK2) = "Midpoint RK2"

order(::SSPRK3) = 3
name(::SSPRK3) = "SSP-RK3"

order(::RK4) = 4
name(::RK4) = "Runge-Kutta 4"