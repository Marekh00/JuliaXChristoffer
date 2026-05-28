module DiffPakke

import LinearAlgebra
using Plots
using PrettyTables
using Statistics
using LaTeXStrings

include("Problems.jl")
include("Solution.jl")
include("Solve.jl")

include("Benchmark.jl")

include("BenchTable.jl")

include("BenchPlot.jl")
include("PlotAnnotation.jl")

include("NumMet/Interface.jl")
include("NumMet/Eksplisitt.jl")
include("NumMet/Implisitt.jl")
include("NumMet/MethodMetadata.jl")

export ODEProblem, solve, OrderAnalysis, Benchmark, BenchPlot, BenchTable, BenchRow 
export BenchCurve, get_anchor, reference_curve, estimated_order, order_annotation 
export plot_methods!, plot_global_references!, plot_local_references!
export annotation_global, annotation_local, annotation_policy, get_global_anchor, place_annotation

export FEuler, RK4, Heun, MidpointRK2, SSPRK3

end