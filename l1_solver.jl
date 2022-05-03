#cd(raw"D:\Shared Folders\Ingé Exam Bac1\Numerical Optimisation\project")
include("utilities.jl")
using JuMP
using Gurobi
using ImageView, Images

#M3042
#Runtime: 250.12 seconds
#objective_value(model) = 356.2141173120986
#M1521
#Runtime: 120.88 seconds.
#objective_value(model) = 303.4164605097025
#M1014
#Runtime: 39.64 seconds.
#objective_value(model) =  271.65350746657117
#M608
#Runtime: 12.34 seconds.
#objective_value(model) =  230.60101297748645
function l1_solver(M, N, m, phi, psi)
    theta = phi * psi
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "Presolve", 0)
    set_optimizer_attribute(model, "Method", 2)
    @variable(model, t[1:N]>=0)
    @variable(model, x[1:N])
    @constraint(model, theta * x .== m)
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

r = l1_solver(1521, 6084, measurements, measurement_matrix, basis_matrix)
println("converting array to matrix...\n")
mat = reshape(r,(78,78))
imshow(mat)
save("reconstructed_l1_M1521.png", colorview(Gray, mat))

println("All done!\n")
