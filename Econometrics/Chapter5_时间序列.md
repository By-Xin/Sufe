  # 第五章 时间序列模型

  ## 5.1 时间序列模型的序列相关性

  ### 5.1.1 基本概念

  讨论模型：
  $$Y_t = \beta_0 + \beta_1X_{t1}+\cdots+\beta_kX_{tk}+\mu_t$$

  - 一阶序列相关/自相关定义：
  $$E(\mu_t\mu_{t-1})\neq 0 $$

  - 一阶序列相关等价形式：
  $$\mu_t = \rho \mu_{t-1}+\epsilon_t$$
  其中称$\rho$为ACF. $\epsilon_t$ 满足零均值,同方差,彼此不相关.

  ### 5.1.2 产生原因

  - 经济变量的固有惯性
  - 模型设定偏误
  - 数据的处理
    - 有些例如月度数据为了统一频率会平均为季度数据，这样的处理会带来一定的相关性

  ### 5.1.3 相关性后果

  - 参数估计非有效
  - 显著性检验无意义
  - 预测失效

  ### 5.1.4 相关性检验

  - 图示法
  - 回归检验法
    - 检验方法：以$e_t$为被解释变量，以$e_{t-1},e_{t-2},e_{t-1}^2$等滞后项的残差作为解释变量建立回归方程
    $$e_t = \rho e_{t-1}+\epsilon_t$$
    检验方程是否显著成立.
  - D.W.检验法
    - 检验假设
      - 解释变量是严格的**外生变量**
      - 理论模型：$\mu_t = \rho \mu_{t-1}+\epsilon_t$
      - 含有截距项
      - 模型中不应该含有$Y_{t-1}$等被解释变量的滞后项作为解释变量
    - 检验内容：$H_0: \rho=0$，即**不存在一阶自回归**
    - 检验统计量：
    $$D.W. = \frac{\sum_{t=2}^n(e_t-e_{t-1})^2}{\sum_{t=1}^ne_t^2}$$
    - 检验结果解读：
      - 若完全一阶正相关，$\rho\approx1, D.W.\approx0$
      - 若完全一阶负相关，$\rho\approx-1,D.W.\approx4$
      - 若完全不相关，$\rho = 0, D.W. = 2$
  - Lagrange Multiplier 检验法
    - 检验思想
      - 构造辅助方程
      $$e_t =\beta_0 + \beta_1X_{t1}+\cdots+\beta_kX_{tk}+\rho_1 e_{t-1}+\cdots+\rho_p e_{t-p}+\epsilon_t$$
      - 通过OLS得到该方程的$n-p，R^2$
      - 计算检验统计量
      $$LM = (n-p)R^2\sim \chi^2(p)$$
        - 若检验统计量的$p<\alpha$，说明可能存在最大为$p$阶相关性
      - 辅助回归方程中各个$e_{k}$对应的t检验则说明在该阶上是否存在着相关性

  ### 5.1.5 对相关性数据的建模
  
  #### 方法一：广义最小二乘法

  #### 方法二：广义差分法
  - 回忆，这里的原始模型为：
  $$Y_t = \beta_0 + \beta_1X_{t1}+\cdots+\beta_kX_{tk}+\mu_t ~~~~\ast$$
  - 之所以存在序列相关性，是因为下式成立（即序列相关性的定义）：
  $$\mu_t = \rho_1 \mu_{t-1}+\cdots+\rho_p\mu_{t-p}+\epsilon_t ~~~~ \star $$
  - 为了将$\ast$中$\mu_t$项的相关性去除，这里的想法就是在$\ast$的左右两侧同时减掉$\rho_1\mu_{t-1},\cdots,\rho_p\mu_{t-p}$
  - 而为了出现上述相关项，对$\ast$进行如下处理可以生成：
  $$\rho_1Y_{t-1}=\rho_1\beta_0 + \rho_1\beta_1X_{t-1,1}+\cdots+\rho_1\beta_kX_{t-1,k}+\boxed{\red{\rho_1\mu_{t-1}}}
  ~~(1)\\\vdots\\\rho_pY_{t-p}=\rho_p\beta_0 + \rho_p\beta_1X_{t-p,1}+\cdots+\rho_p\beta_kX_{t-p,k}+\boxed{\red{\rho_p\mu_{t-p}}}~~(p)$$
  - 将$\ast$左右两侧分别减去$(1)\cdots(p)$这p个式子，泽克认为得到了一个不含有相关性的广义差分模型，可以直接应用OLS即可
  - 广义差分发会损失第一次观测数据，这对于小样本而言可能有较强影响
  - 通过Prais-Winsten变换可以得到第一次观测：
  $$Y_1^*=\sqrt{1-\rho^2}Y_1,~~X_{1j}^*=\sqrt{1-\rho^2}X_{1j}$$
  - 此时的估计结果完全等同广义最小二乘

  #### 序列相关系数$\rho$的估计

  **Cochrane-Orcutt迭代法**
  - 该方法对于如下三个方程进行迭代：
    1. 原始模型：
  $$Y_t = \beta_0 + \beta_1X_{t1}+\cdots+\beta_kX_{tk}+\mu_t ~~~~\ast$$
    2. 序列相关性定义：
  $$\mu_t = \rho_1 \mu_{t-1}+\cdots+\rho_p\mu_{t-p}+\epsilon_t ~~~~ \star$$
    3. 广义差分模型：
  $$\begin{aligned}
  Y_t - \rho_1Y_{t-1}-\cdots-\rho_pY_{t-p}=&\beta_0(1-\rho_1-\cdots-\rho_p)+\\&\beta_1(X_{t1}-\rho_1X_{t-1,1}-\cdots-\rho_pX_{t-p,1})+\\&\cdots+\beta_k(\cdots)+\epsilon_t   ~~~~\diamond
  \end{aligned}$$

  - 迭代过程
    1. 通过OLS对方程1$\ast$进行估计得到$\hat\beta,\hat\mu_t$
    2. 将$\hat\mu_t$作为观测值代入$\star$进行OLS得到$\hat\rho_1\cdots\hat\rho_p$
    3. 将$\hat\rho_1\cdots\hat\rho_p$作为已知参数代入$\diamond$得到1次迭代更新后的$\hat\beta^*$
    4. 将$\hat\beta^*$再次代回$\ast$得到$\mu_t^*$
    5. 将$\mu_t^*$代回$\star$即可得到一次迭代后的更新$\hat\rho^*$
    ……
    以此类推，即可通过该循环结构迭代估计$\rho$

 - Cochrane-Orcutt的性质与评价
   - 若相关系数是通过估计得到的，此时的模型为Feasible GLM
   - F-GLM在小样本下有偏，大样本下一致，大样本渐近有效