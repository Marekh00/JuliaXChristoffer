struct ODESolution{T,U}
    t::Vector{T}
    u::Vector{U}

end

Base.getindex(sol::ODESolution, i::Int) = sol.u[i]
Base.firstindex(sol::ODESolution) = firstindex(sol.u)
Base.lastindex(sol::ODESolution) = lastindex(sol.u)

Base.length(sol::ODESolution) = length(sol.u)
Base.iterate(sol::ODESolution, state=1) = state > length(sol) ? nothing : (sol[state], state + 1)