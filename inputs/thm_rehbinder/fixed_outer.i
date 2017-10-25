[Mesh]
  type = AnnularMesh
  nr = 40
  nt = 16
  rmin = 0.1
  rmax = 1
  tmin = 0.0
  tmax = 1.570796326795
  growth_r = 1.1
[]

[MeshModifiers]
  [./make3D]
    type = MeshExtruder
    bottom_sideset = bottom
    top_sideset = top
    extrusion_vector = '0 0 1'
    num_layers = 1
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  PorousFlowDictator = dictator
  biot_coefficient = 1.0
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./porepressure]
  [../]
  [./temperature]
  [../]
[]

[BCs]
  [./plane_strain]
    type = PresetBC
    variable = disp_z
    value = 0
    boundary = 'top bottom'
  [../]
  [./ymin]
    type = PresetBC
    variable = disp_y
    value = 0
    boundary = tmin
  [../]
  [./xmin]
    type = PresetBC
    variable = disp_x
    value = 0
    boundary = tmax
  [../]

  [./cavity_temperature]
    type = DirichletBC
    variable = temperature
    value = 1000
    boundary = rmin
  [../]
  [./cavity_porepressure]
    type = DirichletBC
    variable = porepressure
    value = 1E6
    boundary = rmin
  [../]
  [./cavity_zero_effective_stress_x]
    type = Pressure
    component = 0
    variable = disp_x
    function = 1E6
    boundary = rmin
    use_displaced_mesh = false
  [../]
  [./cavity_zero_effective_stress_y]
    type = Pressure
    component = 1
    variable = disp_y
    function = 1E6
    boundary = rmin
    use_displaced_mesh = false
  [../]

  [./outer_temperature]
    type = PresetBC
    variable = temperature
    value = 0
    boundary = rmax
  [../]
  [./outer_pressure]
    type = PresetBC
    variable = porepressure
    value = 0
    boundary = rmax
  [../]
  [./fixed_outer_x]
    type = PresetBC
    variable = disp_x
    value = 0
    boundary = rmax
  [../]
  [./fixed_outer_y]
    type = PresetBC
    variable = disp_y
    value = 0
    boundary = rmax
  [../]
[]

[AuxVariables]
  [./stress_rr]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./stress_pp]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./stress_rr]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_rr
    scalar_type = RadialStress
    point1 = '0 0 0'
    point2 = '0 0 1'
  [../]
  [./stress_pp]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_pp
    scalar_type = HoopStress
    point1 = '0 0 0'
    point2 = '0 0 1'
  [../]
[]

[Modules]
  [./FluidProperties]
    [./the_simple_fluid]
      type = SimpleFluidProperties
      thermal_expansion = 0.0
      bulk_modulus = 1E12
      viscosity = 1.0E-3
      density0 = 1000.0
      cv = 1000.0
      cp = 1000.0
      porepressure_coefficient = 0.0
    [../]
  [../]
[]

[PorousFlowBasicTHM]
  coupling_type = ThermoHydroMechanical
  multiply_by_density = false
  add_stress_aux = true
  simulation_type = steady
  porepressure = porepressure
  temperature = temperature
  gravity = '0 0 0'
  fp = the_simple_fluid
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1E10
    poissons_ratio = 0.2
  [../]
  [./strain]
    type = ComputeSmallStrain
    eigenstrain_names = thermal_contribution
  [../]
  [./var_dependence]
    type = DerivativeParsedMaterial
    function = temperature
    args = temperature
    f_name = var_dep
    enable_jit = true
    derivative_order = 2
  [../]
  [./thermal_contribution]
    type = ComputeVariableEigenstrain
    eigen_base = '1E-6 1E-6 1E-6 0 0 0' # thermal expansion = 1E-6
    prefactor = var_dep
    args = temperature
    eigenstrain_name = thermal_contribution
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./porosity]
    type = PorousFlowPorosityConst # only the initial value of this is ever used
    porosity = 0.1
  [../]
  [./biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 1E12
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-12 0 0   0 1E-12 0   0 0 1E-12'
  [../]
  [./thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    fluid_coefficient = 1E-6
    drained_coefficient = 1E-6
  [../]
  [./thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1E6 0 0  0 1E6 0  0 0 1E6'
  [../]
[]

[VectorPostprocessors]
  [./P]
    type = LineValueSampler
    start_point = '0.1 0 0'
    end_point = '1.0 0 0'
    num_points = 10
    sort_by = x
    variable = porepressure
  [../]
  [./T]
    type = LineValueSampler
    start_point = '0.1 0 0'
    end_point = '1.0 0 0'
    num_points = 10
    sort_by = x
    variable = temperature
  [../]
  [./U]
    type = LineValueSampler
    start_point = '0.1 0 0'
    end_point = '1.0 0 0'
    num_points = 10
    sort_by = x
    variable = disp_x
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_rtol'
    petsc_options_value = 'gmres      asm      lu           1E-8'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = Newton
[]

[Outputs]
  file_base = fixed_outer
  execute_on = timestep_end
  csv = true
[]
