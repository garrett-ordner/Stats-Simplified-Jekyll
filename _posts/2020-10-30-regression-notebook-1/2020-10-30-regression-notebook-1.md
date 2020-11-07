---
title: "Regression Notes - 1"
author: Garrett
layout: post
categories:
- Stats Methods
- MTD-Reg
tags:
- regression
- methods
---

This is the first notebook covering regression topics.  It starts with basic estimation and diagnostics.  This example uses a dataset I'm familiar with through work experience, but it isn't ideal for demonstrating more advanced topics.

The sample data I'm using for this is 3_3_Solar_Y2019.xlsx from form EIA-860, available [here](https://www.eia.gov/electricity/data/eia860/).  The data contains generator-level solar energy data reported by utilities to the Energy Information Administration for calendar year 2019.  For reasons that will shortly become clear, I am only interested in photovoltaic (PV) generators.

With respect to PV generators, this is a proxy for the size of the installation (bear in mind that a utility-owned PV generator as reported in the data often consists of multiple panels in a "solar farm", but the panels in an installation should all have the same tilt).  I'll be regressing this capacity data on the panel tilt angle to see if there is any relationship while also controlling for a few other factors that could also affect installation capacity. 

First, I'll import the data and do some basic visualizations on generation capacity (the amount of power in megawatts that can be output by the generator) and compare it to that of thermal solar installations.

```python
#import libraries and import data as dataframe
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
data = pd.read_excel (r'C:\Users\garre\Documents\Python Scripts\datasets\EIA-860\3_3_Solar_Y2019.xlsx', sheet_name = 'Operable', header=1)


```


```python

data.boxplot(column = 'Nameplate Capacity (MW)', by = 'Prime Mover', figsize = (4,8) )

```




    <AxesSubplot:title={'center':'Nameplate Capacity (MW)'}, xlabel='Prime Mover'>




    
![png](_posts\2020-10-30-regression-notebook-1/output__2_1.png)
    



```python
groupedbypm = data.groupby(by = data['Prime Mover']).sum()
plt.pie(x = groupedbypm['Nameplate Capacity (MW)'], labels = groupedbypm.index )
```




    ([<matplotlib.patches.Wedge at 0x1ee05b98b80>,
      <matplotlib.patches.Wedge at 0x1ee05b9e0a0>,
      <matplotlib.patches.Wedge at 0x1ee05b9e520>],
     [Text(1.099376518408859, 0.03703067338323363, 'CP'),
      Text(-1.096464773848027, 0.08811923575698509, 'PV'),
      Text(1.0928768186678455, -0.12498103543517913, 'ST')])




    
![png](_posts\2020-10-30-regression-notebook-1/output__3_1.png)
    


While they tend to be much larger than photovoltaic (PV) generators, solar thermal plants (CP and ST) are so few in number that they comprise only a small fraction of utility-owned solar generation capacity.

I'm interested in the relationship between PV panel tilt angle and the generator's inverter loading ratio (the ratio of DC capacity to AC (nameplate) capacity).

First, I need to do some cleaning.  I want to create a dataframe that only contains PV solar installations whose tilt angle was reported.  I also need to refactor the tilt angle variable from object to float.  Finally, I need to create a variable for the ILR.

There are some datapoints with unrealistically high ILR values.  These are assumed to be due to reporting errors.  Conservatively, we will drop observations with ILR values higher than two.


```python
#create dataframe limited to photovoltaic generators whose tilt angle was reported
pvdata = data[(data['Prime Mover'] == 'PV') & (data['Tilt Angle']!=" ")].copy()
pvdata['Tilt Angle'] = pd.to_numeric(pvdata['Tilt Angle'])
#calculate Inverter Loading Ratio
pvdata['ILR'] = pvdata['DC Net Capacity (MW)']/pvdata['Nameplate Capacity (MW)']
pvdata['ILR'] = pd.to_numeric(pvdata['ILR'])
pvdata = pvdata.loc[pvdata['ILR']<=2]
```


```python
pvdata['ILR'].plot.box(figsize = (4,8) )
```




    <AxesSubplot:>




    
![png](_posts\2020-10-30-regression-notebook-1/output__6_1.png)
    



```python
#scatter plot
plt.plot(pvdata['Tilt Angle'], pvdata['ILR'], 'o')
```




    [<matplotlib.lines.Line2D at 0x1ee0874fa60>]




    
![png](_posts\2020-10-30-regression-notebook-1/output__7_1.png)
    



```python
#obtain pearson correlation coefficient
from scipy.stats import pearsonr
pearsonr(pvdata['Tilt Angle'], pvdata['ILR'])
```




$\displaystyle \left( 0.08111342090515408, \  2.274360325748276e-06\right)$




```python
pearsonr(pvdata['Tilt Angle'], pvdata['Operating Year'])
```




$\displaystyle \left( 0.17748663027514733, \  2.23648978601648e-25\right)$



The first value in the tuple returned by the function is the coefficient.  The second value is a two-tailed p-value. The variables don't appear to be strongly correlated.  Controlling for  installation age might reveal a relationship, so let's continue anyway. Let's regress ILR on tilt angle, the year it was built.


```python
import statsmodels.formula.api as sm
import statsmodels.api as sma
model = sm.ols(formula = "pvdata['ILR']~pvdata['Tilt Angle']+pvdata['Operating Year']", data = pvdata).fit(cov_type='HC1')
print(str(model.summary()))
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:          pvdata['ILR']   R-squared:                       0.055
    Model:                            OLS   Adj. R-squared:                  0.054
    Method:                 Least Squares   F-statistic:                     93.10
    Date:                Thu, 05 Nov 2020   Prob (F-statistic):           4.35e-40
    Time:                        17:40:04   Log-Likelihood:                 1566.2
    No. Observations:                3388   AIC:                            -3126.
    Df Residuals:                    3385   BIC:                            -3108.
    Df Model:                           2                                         
    Covariance Type:                  HC1                                         
    ============================================================================================
                                   coef    std err          z      P>|z|      [0.025      0.975]
    --------------------------------------------------------------------------------------------
    Intercept                  -24.2847      2.010    -12.079      0.000     -28.225     -20.344
    pvdata['Tilt Angle']         0.0005      0.000      2.618      0.009       0.000       0.001
    pvdata['Operating Year']     0.0127      0.001     12.687      0.000       0.011       0.015
    ==============================================================================
    Omnibus:                       51.091   Durbin-Watson:                   1.203
    Prob(Omnibus):                  0.000   Jarque-Bera (JB):               79.362
    Skew:                          -0.145   Prob(JB):                     5.84e-18
    Kurtosis:                       3.692   Cond. No.                     1.50e+06
    ==============================================================================
    
    Notes:
    [1] Standard Errors are heteroscedasticity robust (HC1)
    [2] The condition number is large, 1.5e+06. This might indicate that there are
    strong multicollinearity or other numerical problems.
    


```python
fitted = pd.DataFrame(model.fittedvalues, columns = ['Fitted'])
resid = pd.DataFrame(model.resid, columns = ['Resid'])
pvdata['yhat'] = fitted['Fitted']
pvdata['resid'] = resid['Resid']
pvdata.to_excel(r'C:\Users\garre\Documents\Python Scripts\datasets\EIA-860\post_reg_data.xlsx')
```


```python
from statsmodels.stats.stattools import jarque_bera
from sympy import *
init_printing(use_unicode=True)
name = ['Jarque-Bera', 'Chi^2 two-tail prob.', 'Skew', 'Kurtosis']
normaltest = jarque_bera(model.resid)
x = (name, normaltest)
for line in x:
    print(*line)
```

    Jarque-Bera Chi^2 two-tail prob. Skew Kurtosis
    79.36218170079768 5.844148028089456e-18 -0.1446461440730232 3.6917353539381383
    

Jarque-Bera test results are reassuring, with skewness extremely close to 0, and kurtosis not far off from 3.


```python
sma.graphics.plot_partregress_grid(model).tight_layout(pad=1.0)
```


    
![png](_posts\2020-10-30-regression-notebook-1/output__15_0.png)
    



```python
sma.graphics.plot_regress_exog(model,"pvdata['Tilt Angle']" ).tight_layout(pad=1.0)
```


    
![png](_posts\2020-10-30-regression-notebook-1/output__16_0.png)
    



```python
sma.graphics.plot_regress_exog(model,"pvdata['Operating Year']" ).tight_layout(pad=1.0)
```


    
![png](_posts\2020-10-30-regression-notebook-1/output__17_0.png)
    



```python
plt.plot(model.fittedvalues,model.resid,   'o')
```




    [<matplotlib.lines.Line2D at 0x1ee0db36a00>]




    
![png](_posts\2020-10-30-regression-notebook-1/output__18_1.png)
    


This is bizarre:  A subset of the residuals form a perfect line.


```python
plt.plot(model.fittedvalues[model.resid<0], model.resid[model.resid<0],   'o')
```




    [<matplotlib.lines.Line2D at 0x1ee091bc580>]




    
![png](_posts\2020-10-30-regression-notebook-1/output__20_1.png)
    


Further analysis of the data shows that these residuals correspond to an ILR value of 1:


```python
plt.plot(pvdata['yhat'][pvdata['ILR']==1], pvdata['resid'][pvdata['ILR']==1],  'o')
```




    [<matplotlib.lines.Line2D at 0x1ee05b68ee0>]




    
![png](_posts\2020-10-30-regression-notebook-1/output__22_1.png)
    



```python
pvdata['Tilt Angle log'] = np.log(pvdata['Tilt Angle']+1)
pvdata['ILR log'] = np.log(pvdata['ILR'])
linearlogmodel = sm.ols(formula = "pvdata['ILR']~pvdata['Tilt Angle log']+pvdata['Operating Year']+pvdata['Crystalline Silicon?']", data = pvdata).fit()
loglinearmodel = sm.ols(formula = "pvdata['ILR log']~pvdata['Tilt Angle']+pvdata['Operating Year']+pvdata['Crystalline Silicon?']", data = pvdata).fit()
loglogmodel =  sm.ols(formula = "pvdata['ILR log']~pvdata['Tilt Angle log']+pvdata['Operating Year']+pvdata['Crystalline Silicon?']", data = pvdata).fit()
```


```python
plt.plot(loglinearmodel.resid, loglinearmodel.fittedvalues,  'o')
plt.show()
plt.plot(linearlogmodel.resid, linearlogmodel.fittedvalues,  'o')
plt.show()
plt.plot(loglogmodel.resid, loglogmodel.fittedvalues,  'o')
plt.show()
```


    
![png](_posts\2020-10-30-regression-notebook-1/output__24_0.png)
    



    
![png](_posts\2020-10-30-regression-notebook-1/output__24_1.png)
    



    
![png](_posts\2020-10-30-regression-notebook-1/output__24_2.png)
    



```python

```
