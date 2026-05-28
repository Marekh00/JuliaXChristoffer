function solve(prob::ODEProblem, method; h)

    f = prob.f
    t0, tf = prob.tspan
    u0 = prob.u0

    N = Int(floor((tf - t0)/h))

    t = Vector{typeof(t0)}(undef, N+1)
    u = Vector{typeof(u0)}(undef, N+1)

    t[1] = t0
    u[1] = u0

    for n in 1:N
        t[n+1] = t[n] + h
        u[n+1] = step(method, u[n], t[n], f, h)
    end

    return ODESolution(t, u)
end

function PrintSolve(prob::ODEProblem, method; h)
    VectorString = String[]
    sol = solve(prob, method; h)
    StringT = string(sol.t)
    StringU = string(sol.u)
    
    push!(VectorString, StringT)
    push!(VectorString, StringU)

    return VectorString
end