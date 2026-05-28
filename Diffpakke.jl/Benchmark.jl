struct MethodResult
    method
    h::Vector{Float64}
    error::Vector{Float64}
    order::Vector{Float64}
end

struct BenchmarkResult
    methods::Vector{MethodResult}
    problem::String
end

function OrderAnalysis(method, prob::ODEProblem, exact_solution, h)
    error = zeros(length(h))
    order = zeros(length(h)-1)
    
    T = prob.tspan[2]

    for i in 1:length(h)
        sol = solve(prob, method; h = h[i])
        error[i] = LinearAlgebra.norm(sol[end] - exact_solution(T))
    end

    for i in 1:length(order)
        order[i] = (log(error[i+1]) -log(error[i])) / (log(h[i+1]) - log(h[i]))
    end

    return error, order
end

function Benchmark(methods, prob, exact_solution, h0)

    h = [h0, h0/2, h0/4, h0/8]

    results = MethodResult[]

    for m in methods

        error, order = OrderAnalysis(m, prob, exact_solution, h)

        push!(results, MethodResult(m, h, error, order))
    end

    return BenchmarkResult(results, string(typeof(prob)))
end

function estimated_order(m::MethodResult)
    x = log.(m.h)
    y = log.(m.error)
    return mean(diff(y) ./ diff(x))
end

function BenchRow(m::MethodResult)

     Row = (method = string(name(m.method)),
           theoretical_order = order(m.method),
           h = m.h[end],
           order_estimate = estimated_order(m),
           global_error = m.error[end])
    return Row
end

function BenchCurve(m::MethodResult)
    Curve = (method = string(name(m.method)), h = m.h, global_error = m.error)
    return Curve
end
