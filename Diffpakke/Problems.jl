struct ODEProblem{F,T,U}
    f::F
    tspan::Tuple{T,T}
    u0::U
end