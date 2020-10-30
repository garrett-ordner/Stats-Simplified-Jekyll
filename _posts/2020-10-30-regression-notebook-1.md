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

This is the first notebook covering regression topics.  It starts with basic estimation and diagnostics.  It's possible I may delve into matrix algebra in a later post.

The sample data I'm using for this is 3_1_Generator_Y2019.xlsx from form EIA-860, available [here](https://www.eia.gov/electricity/data/eia860/).  The data contains generator-level data reported by utilities to the Energy Information Administration for calendar year 2019.

```python
import pandas as pd
data = pd.read_excel (r'C:\Users\garre\Documents\Job Search\0_Human Capital Development\Statistical Methods\EIA-860\3_1_Generator_Y2019.xlsx', sheet_name = 'Operable', header=1)
```


```python
print(data.count)
```

    <bound method DataFrame.count of        Utility ID                         Utility Name  Plant Code  \
    0           63560       TDX Sand Point Generating, LLC           1   
    1           63560       TDX Sand Point Generating, LLC           1   
    2           63560       TDX Sand Point Generating, LLC           1   
    3           63560       TDX Sand Point Generating, LLC           1   
    4           63560       TDX Sand Point Generating, LLC           1   
    ...           ...                                  ...         ...   
    22726       63585          POET Biorefining - Portland       63922   
    22727       63591           POET  Biorefining - Gowrie       63923   
    22728       63587  POET Biorefining - Alexandria, LLC.       63924   
    22729       63594      POET Biorefining - Leipsic, LLC       63927   
    22730       56476                             Ameresco       63928   
    
                                  Plant Name State          County Generator ID  \
    0                             Sand Point    AK  Aleutians East            1   
    1                             Sand Point    AK  Aleutians East            2   
    2                             Sand Point    AK  Aleutians East            3   
    3                             Sand Point    AK  Aleutians East            5   
    4                             Sand Point    AK  Aleutians East          WT1   
    ...                                  ...   ...             ...          ...   
    22726        POET Biorefining - Portland    IN             Jay        G-745   
    22727          POET Biorefining - Gowrie    IA         Webster            1   
    22728  POET Biorefining- Alexandria, LLC    IN         Madison            1   
    22729    POET Biorefining - Leipsic, LLC    OH          Putnam            1   
    22730                 Vacaville Hospital    CA          Solano         6701   
    
                          Technology Prime Mover Unit Code  ...  \
    0              Petroleum Liquids          IC       NaN  ...   
    1              Petroleum Liquids          IC       NaN  ...   
    2              Petroleum Liquids          IC       NaN  ...   
    3              Petroleum Liquids          IC       NaN  ...   
    4           Onshore Wind Turbine          WT       NaN  ...   
    ...                          ...         ...       ...  ...   
    22726  Natural Gas Steam Turbine          ST       NaN  ...   
    22727  Natural Gas Steam Turbine          ST       NaN  ...   
    22728  Natural Gas Steam Turbine          ST       NaN  ...   
    22729  Natural Gas Steam Turbine          ST       NaN  ...   
    22730         Solar Photovoltaic          PV       NaN  ...   
    
          Planned Energy Source 1 Planned New Nameplate Capacity (MW)  \
    0                         NaN                                       
    1                         NaN                                       
    2                         NaN                                       
    3                         NaN                                       
    4                         NaN                                       
    ...                       ...                                 ...   
    22726                     NaN                                       
    22727                     NaN                                       
    22728                     NaN                                       
    22729                     NaN                                       
    22730                     NaN                                       
    
          Planned Repower Month Planned Repower Year Other Planned Modifications?  \
    0                                                                         NaN   
    1                                                                         NaN   
    2                                                                         NaN   
    3                                                                         NaN   
    4                                                                         NaN   
    ...                     ...                  ...                          ...   
    22726                                                                     NaN   
    22727                                                                     NaN   
    22728                                                                     NaN   
    22729                                                                     NaN   
    22730                                                                     NaN   
    
           Other Modifications Month Other Modifications Year Multiple Fuels?  \
    0                                                                       N   
    1                                                                       N   
    2                                                                       N   
    3                                                                       N   
    4                                                                     NaN   
    ...                          ...                      ...             ...   
    22726                                                                   N   
    22727                                                                   N   
    22728                                                                   N   
    22729                                                                   N   
    22730                                                                 NaN   
    
          Cofire Fuels? Switch Between Oil and Natural Gas?  
    0               NaN                                 NaN  
    1               NaN                                 NaN  
    2               NaN                                 NaN  
    3               NaN                                 NaN  
    4               NaN                                 NaN  
    ...             ...                                 ...  
    22726           NaN                                 NaN  
    22727           NaN                                 NaN  
    22728           NaN                                 NaN  
    22729           NaN                                 NaN  
    22730           NaN                                 NaN  
    
    [22731 rows x 73 columns]>
    


```python

```
