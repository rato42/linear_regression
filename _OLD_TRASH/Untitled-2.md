Results for Brasil:
                  Generalized Linear Model Regression Results                   
================================================================================
Dep. Variable:     mental_health_visits   No. Observations:                   72
Model:                              GLM   Df Residuals:                       64
Model Family:          NegativeBinomial   Df Model:                            7
Link Function:                      Log   Scale:                          1.0000
Method:                            IRLS   Log-Likelihood:                -1017.3
Date:                  qui, 01 mai 2025   Deviance:                      0.18876
Time:                          21:10:10   Pearson chi2:                    0.183
No. Iterations:                       4   Pseudo R-squ. (CS):            0.03078
Covariance Type:                    HAC                                         
=====================================================================================
                        coef    std err          z      P>|z|      [0.025      0.975]
-------------------------------------------------------------------------------------
Intercept             2.7943      0.015    182.923      0.000       2.764       2.824
periodo               0.0117      0.001     10.248      0.000       0.009       0.014
Pandemia_Step         0.1682      0.033      5.124      0.000       0.104       0.233
Pandemia_Trend       -0.0153      0.003     -5.759      0.000      -0.021      -0.010
PosPandemia_Step     -0.1916      0.050     -3.855      0.000      -0.289      -0.094
PosPandemia_Trend     0.0011      0.002      0.697      0.486      -0.002       0.004
cos1                 -0.0093      0.005     -2.028      0.043      -0.018      -0.000
sin1                 -0.0089      0.011     -0.801      0.423      -0.031       0.013
=====================================================================================
Dispersion α: 1.0000


                    Value     Std.Error DF  t-value p-value
(Intercept)        2.8015365 0.03100605 64 90.35452  0.0000
periodo            0.0110666 0.00190369 64  5.81325  0.0000
Pandemia_Step      0.1853152 0.04038766 64  4.58841  0.0000
Pandemia_Trend    -0.0146825 0.00303215 64 -4.84228  0.0000
PosPandemia_Step  -0.1746914 0.07948229 64 -2.19787  0.0316
PosPandemia_Trend  0.0023446 0.00330596 64  0.70922  0.4808
cos1              -0.0061915 0.00596404 64 -1.03815  0.3031
sin1              -0.0088416 0.00782502 64 -1.12991  0.2627