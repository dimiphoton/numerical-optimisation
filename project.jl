cd(raw"D:\Shared Folders\Ingé Exam Bac1\Numerical Optimisation\project")
include("txt_parser.jl")

basis_matrix = txt_parser(6084, 6084, "basis_matrix.txt")
measurement_matrix = txt_parser(3042, 6084, "measurement_matrix_M3042.txt")
measurements = txt_parser(3042, 1, "uncorrupted_measurements_M3042.txt")
