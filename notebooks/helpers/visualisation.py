import pandas as pd


def visualise_latency_cdf(results_cfs, results_llf, fig, ax,workload,func_count,density=1):
    dfs = [df for df, _, _, _, _ in results_cfs.values()]
    dfs_llf = [df for df, _, _, _, _ in results_llf.values()]


    dfs = [pd.Series(df.to_numpy().flatten()) for df in dfs]
    dfs_llf = [pd.Series(df.to_numpy().flatten()) for df in dfs_llf]


    dfb = dfs[0]

    for index, count in enumerate(list(results_cfs.keys())):

#         print(index, count)
        
        if (count == func_count):

            quantile = 0.95

            dfb[dfb<dfb.quantile(quantile)].hist(cumulative=True, density=density, bins=1000,
                                                 histtype='step',
                                                  label=f'{12}-funcs-CFS',ax=ax)

            print(dfb.quantile(0.5),dfb.quantile(0.95))

            df = dfs[index]
            df[df<df.quantile(quantile)].hist(cumulative=True, density=density, bins=1000,
                                              histtype='step',
                                              label=f'{count}-funcs-CFS',ax=ax)
            print(df.quantile(0.5),df.quantile(0.95))
            

            df = dfs_llf[index]
            df[df<df.quantile(quantile)].hist(cumulative=True, density=density, bins=1000,
                                              histtype='step',
                                              label=f'{count}-funcs-CFS-LLF',ax=ax)   
            print(df.quantile(0.5),df.quantile(0.95))
            


            ax.set_title(workload,)
            ax.set_xlabel("milliseconds")