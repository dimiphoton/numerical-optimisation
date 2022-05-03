include("utilities.jl")
using JuMP
using Gurobi
using ImageView, Images, ImageIO
#M3042
#Runtime: 9.68 seconds.
#objective_value(model) = 36.05656256157724
#M1521
#Runtime: 2.79 seconds.
#objective_value(model) = 26.412748663919576
#M1014
#Runtime: 1.60 seconds.
#objective_value(model) = 20.3555758410121
#M608
#Runtime: 0.85 seconds.
#objective_value(model) = 16.22977583463435
function l2_solver(M, N, m, phi, psi)
    theta = phi * psi
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "Presolve", 0)
    @variable(model, t)
    @variable(model, x[1:N])
    @constraint(model, theta * x .== m)
    @constraint(model, [t, (x)...] in SecondOrderCone())
    @objective(model, Min, t)
    println("start to optimize...\n")
    optimize!(model)
    println("optimization done!\n")
    @show objective_value(model)

    r = psi * JuMP.value.(x)
    return r
end

println("loading data...\n")
basis_matrix = unpickler("basis_matrix.pickle");
measurement_matrix = unpickler("measurement_matrix_M608.pickle");
measurements = unpickler("uncorrupted_measurements_M608.pickle");
println("data loaded!\n")

r = l2_solver(608, 6084, measurements, measurement_matrix, basis_matrix)
println("converting array to matrix...\n")
mat = reshape(r,(78,78))

imshow(mat)
save("reconstructed_l2_M608.png", colorview(Gray, mat))

println("All done!\n")
