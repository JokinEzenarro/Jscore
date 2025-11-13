J-Score Calculation for PLSR Models (MATLAB)
===========================================

This repository provides an implementation of the J-Score, a composite diagnostic metric for selecting the optimal number of latent variables (LVs) in Partial Least Squares Regression (PLSR) models.
The method is described in:
Ezenarro, J. (2023). Chemometrics and Intelligent Laboratory Systems, 104883.
https://doi.org/10.1016/j.chemolab.2023.104883

Function Overview
-----------------
report = Jscore(X, Y, LVs)

Inputs:
- X — Matrix of predictors (e.g., spectra). Samples in rows.
- Y — Vector or matrix of reference values.
- LVs — Maximum number of latent variables to evaluate.

Outputs:
- Jscore — Mean J-Score across robustness iterations
- invRPD — Inverse RPD (RMSE / std(Y))
- RMSEratio — 1 – RMSEcal / RMSEcv
- noiseIndex — Noise index of regression coefficients
- invR2 — 1 – adjusted R²
- ResVar — Residual variance

Requirements
-----------
- MATLAB
- Statistics and Machine Learning Toolbox

Important: plsregress conflicts with the version included in PLS_Toolbox. Ensure MATLAB’s native functions have priority.

Citation
--------
If you use this code, must cite:
Ezenarro, J. (2023). A robust diagnostic for selecting latent variables in PLS regression. Chemometrics and Intelligent Laboratory Systems, 104883.
doi.org/10.1016/j.chemolab.2023.104883

License
-------
GNU GPL v3.0 with a Non-Commercial restriction.
- Modification and redistribution allowed under GPLv3.
- Attribution required.
- Commercial use strictly prohibited.

Acknowledgements
----------------
Original methodology by Jokin Ezenarro.
