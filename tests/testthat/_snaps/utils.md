# ic_tbl works as expected

    Code
      ic_tbl(pois_fit, geom_fit, nbinom_fit)
    Output
        distribution       AIC   DeltaAIC          wAIC       BIC   DeltaBIC
      1       nbinom  568.1201   0.000000  9.903974e-01  573.3305   0.000000
      2         geom  577.3923   9.272144  9.602603e-03  579.9974   6.666974
      3         pois 1139.2737 571.153624 9.362155e-125 1141.8789 568.548454
                 wBIC
      1  9.655599e-01
      2  3.444009e-02
      3 3.357771e-124

# ic_tbl works as expected with sort_by = BIC

    Code
      ic_tbl(pois_fit, geom_fit, nbinom_fit, sort_by = "BIC")
    Output
        distribution       AIC   DeltaAIC          wAIC       BIC   DeltaBIC
      1       nbinom  568.1201   0.000000  9.903974e-01  573.3305   0.000000
      2         geom  577.3923   9.272144  9.602603e-03  579.9974   6.666974
      3         pois 1139.2737 571.153624 9.362155e-125 1141.8789 568.548454
                 wBIC
      1  9.655599e-01
      2  3.444009e-02
      3 3.357771e-124

# ic_tbl works as expected with sort_by = none

    Code
      ic_tbl(pois_fit, geom_fit, nbinom_fit, sort_by = "none")
    Output
        distribution       AIC   DeltaAIC          wAIC       BIC   DeltaBIC
      1         pois 1139.2737 571.153624 9.362155e-125 1141.8789 568.548454
      2         geom  577.3923   9.272144  9.602603e-03  579.9974   6.666974
      3       nbinom  568.1201   0.000000  9.903974e-01  573.3305   0.000000
                 wBIC
      1 3.357771e-124
      2  3.444009e-02
      3  9.655599e-01

