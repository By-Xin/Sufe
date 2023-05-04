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
- Lagrange Multiplier Test, 拉格朗日乘子检验 （**B**reusch-**G**odfrey Test）
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

## 5.2 平稳性的检验

## 5.3 协整关系 & 误差修正模型

### 5.3.1 协整关系概念

- **长期均衡**关系
  - 是一种**经济理论概念**
  - 意味着经济系统内部存在着一个长期的均衡关系
  - 如果变量在某一时刻偏离均衡点，则均衡机制将会使得其在下一期回归到均衡状态
  - 模型描述
  $$Y_t = \alpha_0 + \alpha_1 X_t +\mu_t $$
  - 由模型可见，期望$E(Y) = \alpha_0+\alpha_1 X_{t-1}$即为其均衡值

### 5.3.2 协整性的检验

### 5.3.3 均衡关系 v.s. 协整关系

### 5.3.4 误差修正模型

#### 一般差分模型

- 对非平稳时间序列进行差分稳定化，后建立回归分析模型

$$Y_t = \alpha_0 + \alpha_1X_t + \mu_t$$

$$\Delta Y_t = \Delta\alpha_1X_t + v_t$$

#### 误差修正模型

- 应用前提：**具有协整关系**

- 原始模型：
  $$Y_t = \alpha_0 + \alpha_1X_t + \mu_t$$

- 模型推导
  - 假设上述模型具有(1,1)滞后: $Y_t = \beta_0+\beta_1X_t + \beta_2 X_{t-1} +\delta Y_{t-1} +\mu_t $
  - 对上述模型进一步整理化简有：
  $$\Delta Y_t = \beta_1\Delta X_t -\lambda (Y_{t-1} - \alpha_0 - \alpha_1X_{t-1})+\mu_t$$

##### 一阶误差修正模型

$$ \begin{aligned}
 \Delta Y_t &= \beta_1 \Delta X_t -\lambda(Y_{t-1} - \alpha_0 -\alpha_1 X_{t-1})+\mu_t \\&\triangleq  \beta_1 \Delta X_t -\lambda ecm_{t-1} +\mu_t
\end{aligned} $$

##### Granger Representation Theorem

- 若变量$X,Y$协整，则其短期非均衡关系总可以通过一个误差修正模型表述 (represent)

$$ \Delta Y_t = B^k(\Delta Y, \Delta X)-\lambda ecm_{t-1} + \mu_t  $$

- 这里的滞后项可以是多阶滞后

##### 误差修正模型的建立

- **Engle - Granger两步法**
  1. 通过OLS进行协整回归，检验协整关系，估计协整向量（长期均衡关系参数）
  2. 若协整存在，用第一步的残差作为非均衡误差项加入误差修正模型，用OLS估计参数


## 5.4 Granger 因果检验

### 5.4.1 随机时间序列模型

#### ARMA模型

- AR模型中引入**其他变量及相应滞后**，称为自回归分布滞后模型 (Autoregressive Distributed Lag Model, ADL)
- 例如**ADL(p,q)**：
  $$Y_t = \phi_0 + \phi_1 Y_{t-1}+\cdots +\phi_p Y_{t-p}+\gamma_0 X_t +\cdots +\gamma _qX_{t-q}+\mu_t $$
- 对于一个满足回归方程模型的假设的上述模型，OLS估计量是小样本下的BLUE
- 大样本下也可以放松假设得到一致OLS估计量：
  - ${Y,X}$弱相关平稳
  - $E(\mu_t | Y_{t-1},\cdots X_{t-p})=0$
  - 无完全多重共线性

#### VAR模型

$$ Y_t = \mu + A_1 Y_{t-1} +\cdots +A_p Y_{t-p} +\epsilon_t ~(t=1 ,2 ,\cdots ,T)$$

$$ Y = (Y_1 , Y_2 ,\cdots  Y_k)',A_j = [a_{ii,j}], \mu = (\mu_1 , \ldots ,\mu_k)', \epsilon = (\epsilon_1 , \ldots ,\epsilon _k)' $$

- 模型要求：
  - 所有变量都是内生的
  - $E(\epsilon_t | Y_{t-1}\cdots Y_{t-p})=0$
  - $E(\epsilon_t\epsilon_t')=\Sigma$
  - 不存在跨期相关：$E(\epsilon_t\epsilon_s')=0$
- 每个方程可以看作是独立的方程，可以逐个OLS估计每个方程
- 滞后阶数的确定：LR, AIC, BIC等
- VAR的评价：
  - VAR对系统的解释性较差，多用于预测模型
  - VAR更多分析一个**动态平衡系统**，分析系统收到冲击时的动态变化
  - VAR模型的变量顺序会影响模型的结果，在应用模型的时候相当于要事先了解模型之间的因果排序关系

##### 结构向量自回归模型，SVAR

$$ Y_t = \mu + A_0 Y_t + A_1 Y_{t-1}+ \cdots + A_p Y_{t-p} +\epsilon   $$

## 5.4.2 Granger 因果检验

- Granger 因果关系概念
  - 如果两个变量之间，主要是一个变量的**过去**影响两一个变量的**当前**，则存在单向影响关系
  - 若双方互相影响，则存在双向关系

- Granger 因果检验方法
$$ \begin{aligned}
 Y_t = \alpha X_{t-i} +\beta Y_{t-i} +\mu_{1t} ~(1)
 \\ X_t = \lambda X_{t-i} + \delta  Y_{t-i} + \mu_{2t}~ (2)
\end{aligned} $$
  - 若$\alpha $整体显著，则说明$X \to Y$有显著影响
  - 若$\delta $整体显著，则说明$Y \to X$有显著影响

- Granger  检验首先要求序列平稳
