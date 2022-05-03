#cd(raw"D:\Shared Folders\Ingé Exam Bac1\Numerical Optimisation\project")
include("utilities.jl")
using JuMP
using Gurobi
using ImageView, Images, ImageIO
using LinearAlgebra

function robust_l1_solver(M, N, m, phi, psi, eps)
    theta = phi * psi
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "Presolve", 0)
    @variable(model, t[1:N]>=0)
    @variable(model, x[1:N])
    @constraint(model, [eps, (m - theta * x)...] in SecondOrderCone())
    @constraint(model, x .<= t)
    @constraint(model, -t .<= x)
    @objective(model, Min, sum(t))
    println("start to optimize...\n")
    optimize!(model)
    println("optimization done!\n")
    @show objective_value(model)

    r = psi * JuMP.value.(x)
    return r
end

println("loading data...\n")
basis_matrix = unpickler("basis_matrix.pickle");
measurement_matrix = unpickler("measurement_matrix_M1521.pickle");
measurements = unpickler("noisy_measurements_M1521.pickle");
println("data loaded!\n")

r = robust_l1_solver(1521, 6084, measurements, measurement_matrix, basis_matrix, 0.01)
println("converting array to matrix...\n")
mat = reshape(r,(78,78))
imshow(mat)

save("reconstructed_0.01_robust_l1_M1521.png", colorview(Gray, mat))

println("All done!\n")
