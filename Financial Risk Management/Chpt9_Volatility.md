# 波动率

## 波动率与幂律

### 1. 波动率的概念

- 在单位时间内，用连续复利的条件下，某个变量收益波动的**标准差**
- 记$S_i$是第$i$天结束时的某变量价格，则在连续复利下，每日的收益为
  $\ln S_i/S_{i-1}$
- 在研究股票等资产的波动率时，通常认为大多数的资产价格波动发生在交易日中，若假定每年有252个交易日，则年波动率和日波动率可以如下相互转换：

  $$
  \sigma_{year}=\sigma_{day}\times\sqrt{252}
  $$
- 隐含波动率：通过BSM公式计算出的价格反推出的波动率
- VIX指数：S&P500 指数的波动率指数，越大表示波动率越大

### 2. 金融市场的收益分布

- 许多市场变量的收益不服从正态分布，相比而言其呈现尖峰肥尾趋势
  <img src="https://michael-1313341240.cos.ap-shanghai.myqcloud.com/1681807494048.png" alt="1681807494048" style="zoom:33%;" />
- 幂律分布是在金融市场中一些情况下对于收益的更好估计分布，其计算公式：

  $$
  Prob(v>x)=Kx^{-\alpha}
  $$

## 波动率估计模型

### 标准估计方法

- 记$\sigma_n$为在第$n-1$天估计的第$n$天的波动率，$S_i$为在第$i$天末的价格
- 则每日的变化为$u_i=\ln (S_i-S_{i-1})$
- 可以计算每日的变化均值$\bar u = \sum^m_{i=1} u_{n-i}/m$，以及变化的方差$\sum_{i=1}^n(u_{n-i}-\bar u)^2/(n-1)$
- 计算时常用$n$代替$n-1$，并假变化率的期望为0，则有估计：

  $$
  \sigma_n^2=\sum_{i=1}^mu_{n-i}^2/m
  $$
- 进一步也可以将上述的等权重模型根据不同日期的权重进行修正，得到

  $$
  \sigma_n^2=\sum_{i=1}^m\alpha_i u_{n-i}^2\quad(\small{\sum}\alpha_i=1)
  $$

### ARCH(m)

- 在上述模型的基础上增加一项长期平均方差$V_L$，并应用在上述加权模型中：

  $$
  \sigma_n^2=\gamma V_L+\sum_{i=1}^m\alpha_i u_{n-i}^2\quad(\small{\gamma+\sum}\alpha_i=1）
  $$

### EWMA （指数加权移动平均）

- 通过如下递归形式求解：

  $$
  \sigma_n^2=\lambda\sigma_{n-1}^2+(1-\lambda)u_{n-1}^2
  $$
- EWMA的优点

  - 需要的数据较少
  - 每次可以直接根据最新值进行更新而不需要重新计算

### GARCH(1,1)

$$
\sigma_n^2=\gamma V_L+\alpha u_{n-1}^2+\beta\sigma_{n-1}^2 \quad(\gamma+\alpha+\beta=1)
$$

### GARCH(p,q)

$$
\sigma_n^2=\gamma V_L+\sum_{i=1}^p\alpha_i u_{n-i}^2+\sum_{j=1}^q\beta_j\sigma_{n-j}^2 \quad(\gamma+\sum\alpha+\sum\beta=1)
$$
