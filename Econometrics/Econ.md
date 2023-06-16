# 教学大纲

## 3. OLS

#### 3.3 虚拟变量

- 快速生成虚拟变量：`tabulate PROVINCE, generate (DUMMY)`
- 课堂方法：`gen D=0 if VAR=="CITY"` `replace D=1 if VAR=="VILLAGE"`

### 3.4 受约束的线性模型

#### 3.4.1 模型的线性约束

首先按照无约束的方式进行ols，得到 $RSS_U$

再将约束条件带入到模型中，得到有约束的模型，再进行ols得到$RSS_R$

$F=\frac{(RSS_R-RSS_U)/(k_u-k_r)}{RSS_u/(n-k_u-1)}$

> 1. 此处的k不包括常数项
> 2. 这里的自由度是有意义的，df1表示两个方程待估参数个数之差，df2表示更大的模型里*样本量-全部待估参数个数（包括截距项）*

在STATA中，通过 `eret list`可以返回 `reg`的所有计算结果，通过 `scalar VARNAME = ... `就可以把这里的RSS，k等保存下来，也可以相应完成计算。

此外，可以通过 `di invFtail(1, 36, 0.05)` 来显示F分布的右尾部分位数，通过 `di invF(1,36,0.05)` 来显示F分布的左尾部分位数。

#### 3.4.2 检验不同组回归函数之间的差异（结构变动）

**Chow Test**

现有两个回归方程（1）和（2），想要检验这两个方程系数是否显著不同。

在*H0：系数相同* 的条件下，（1）（2）可以合并成一个方程（3），将数据合并，ols，得到一个$RSS_R$。另一方面将这两个方程各自回归，还可以得到$RSS_1,RSS_2$，记$RSS_U=RSS_1+RSS_2$。

$$
F=\frac{(RSS_R-RSS_U)/(k+1)}{RSS_U/(n_1-(k+1)+n_2-(k+1))}
$$

其中df1是表示受约束个数，这里包括截距项在内一共设置了$k+1$个约束；df2是总的样本量减去总的待估参数个数。

## 4. 拓展的线性模型

### 4.1 多重共线性

- 多重共线性的概念
  - $R^2$很大，F显著，但t不显著
- 产生原因
- 多重共线性的后果
  - 完全共线性下$\hat\beta$ 不存在（$X'X$不可逆）
  - OLS非有效
  - 经济含义不合理
- 多重共线性的检验
  - 检验是否存在多重共线性
    - 相关系数法
      - `pwcorr VAR*, star(.05)`
    - 回归结果统计检验法
  - VIF法
    - 已知$y\sim x_1,...,x_p$
    - 回归：$x_k \sim x_1 ,...,x_p $ 可求出一个$R^2_k$
    - 定义：$VIF_k = (1-R^2_k)^{-1}$
    - STATA：`estat vif`
  - 逐步回归检验法（Stepwise Backwards Regression）
    - 向前回归 (pe: pvalue-to-enter) `stepwise, pe(0.1): reg y x*`
    - 向后回归 (pr: pvalue-to-remove) `stepwise, pr(0.1): reg y x*`
      其中0.1指定的是p-value水平

### 4.2 异方差性

- 异方差性的概念
  - 扰动项的协方差函数对角线不相等，非对角线为0
- 异方差性的实证例子
- 异方差性的后果
  - 仍然满足：**无偏、一致性、渐进正态性**
  - t、F检验无效，G-M不成立，不再是BLUE
  - WLS是BLUE
- 异方差性检验
  - 图示法
  - Breusch-Pagan-Godfrey Test **(B-P检验)**
    - 已知方程$Y = \beta_0+\beta_1x_1+\cdots+\beta_k x_k+\epsilon$
    - 构造回归：$\epsilon^2 = \delta_0 + \delta x_1 + \cdots + \delta_k x_k + \mu$
    - 在正式操作的时候，用残差代替误差，检验是否所有的$\delta_1,...,\delta_k$都为0
    - 可以通过辅助回归的F检验判断
    - 也可以通过LM: $nR_e^2 \sim \chi^2(k)$判断
  - **White's** General Heteroscedasticity Test
    - 在B-P检验的基础上引入所有自变量的二次项（包括自身平方和相互的交互项）
- 异方差性的修正（估计方法）
  - 加权最小二乘（WLS）：权重的确定
    - 首先回归 $y \sim x_1,...,x_k$ 得到残差$e$
    - 由于想要估计残差方差，这里用残差的平方进行估计；此外由于要求方差非负，进行先对数再指数的变换；进行回归$ ln(e^2) \sim x_1,...,x_k$，得到残差针对各个变量的估计 $\hat {\ln e}^2$；再指数变换回来$\exp(\hat {\ln e}^2)$
    - 再根据这个方差的倒数为权重进行wls
  - STATA:
    - ```stata
      reg y x1 x2 x3
      predict e, resid
      gen e2 = e^2
      reg ln_e2 x1 x2 x3
      predict ln_e2_hat
      gen e2_hat = exp(ln_e2_hat)
      reg y x1 x2 x3 [aw = 1/e2_hat]
      ```
  - 稳健标准误估计法
    - `reg y x1 x2 x3, robust`

### 4.3 内生性

- 内生性概念
  - 同期相关: $E(\mu_i |X_i)=0$
  - 异期相关: $E(\mu_j|X_j)=0$
- 实证中内生性产生原因
  - 遗漏变量
  - 双向因果
  - 测量误差偏差
- 内生性后果
  - 有偏、非一致性
- 工具变量法
  - 工具变量的选取（原则）
    - 选取的IV与内生型变量高度相关
    - IV与随机干扰项不相关
    - IV与其他变量不高度线性相关
  - 工具变量的应用
  - 2SLS
    - 估计过程
      - 假设方程$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 w + \epsilon$，其中$x_1,x_2$为内生变量，$w$为外生变量，且有工具变量$z_1,z_2,z_3$
      - 第一阶段：
      $$x_1 \sim z_1,z_2,z_3,w \\ x_2 \sim z_1,z_2,z_3,w$$
      得到 $\hat x_1,\hat x_2$
      - 第二阶段：
      $$ y \sim \hat x_1,\hat x_2,w$$
      得到IV估计： $\hat \beta_0,\hat \beta_1,\hat \beta_2,\hat \beta_3$
    - 说明：
      - 所有原模型中已经外生的变量也要参与一阶段回归，这里可以认为外生变量是自己的IV
      - m个内生变量至少需要m个IV才可以
    - STATA：
      - `ivregress 2sls Y X1 X2 (X3 X4 = Z1 Z2 Z3), robust first`
      - `robust`将使用方差稳健的s.e. `first`将显示第一阶段回归结果
      - 由上面的估计过程可以知道，如果有多组内生变量，那么事实上在回归的时候也是对每个内生变量针对所有的IV进行回归一次做出估计的
- 原始变量的内生性检验（Hausman检验）
  - 检验原理：$H_0：所有变量x是外生的$，若原假设成立则ols和2sls的估计结果应该相差不多。因此分别进行两次回归，对回归结果进行比较。
  - STAT:
    - `reg y x1 x2 `  `est store ols`
    - `ivregress 2sls y x1 (x2 = z1 z2)` `est store iv`
    - `haussman iv ols, constant sigmamore`
- 工具变量的外生性检验（过度识别约束检验）
  - 检验原理：当过度识别时，若工具变量确实是外生的（H0），对2sls的残差项进行回归：$ e_{iv} \sim x_1, ... ,x_{k-r}, z_1,...,z_m$中工具变量$z$前的系数应当联合显著为0
  - `estat overid`

## 5. 时间序列

## 5.1 序列相关性

- 相关性概念、定义
- 实证中产生相关性原因
- 相关性后果
  - 估计量非有效
  - 显著性检验失效
  - 预测失效
- 相关性检验
  - 图示法
  - 回归检验法
    - 将$e_t \sim e_{t-1}$的不同滞后阶数进行回归
  - Durbin-Watson检验法（D.W.统计量）
    - $$DW = \frac{\sum_{t=2}^T (e_t - e_{t-1})^2}{\sum_{t=1}^T e_t^2} = 2(1-\hat\rho_1)$$
    - DW=0, rho=1, 正自相关
    - DW=2, rho=0, 无自相关
    - DW=4, rho=-1, 负自相关
    - `estat dwatson`
  - Lagrange-Multiplier检验法（L-M检验）（Breusch-Godfrey Test）
    - 引入辅助回归：$e_t = \gamma_1 e_{t-1} + ... + \gamma_p e_{t-p} + \delta_1 X_{t1}+..._+\delta_k X_{tk} + u_t$
    - $H_0: \gamma_1 = ... = \gamma_p = 0$
    - $LM=(n-p)R^2\sim \chi^2(p)$
    - `estat bgodfrey`
    - 在进行$y\sim x$的回归后，也可以通过调用`dwstat`来获得dw统计量
- 序列相关的处理（补救）
  - 广义最小二乘（GLS）*（FGLS）*
  - 广义差分法
  - 随机误差项的估计：Cochrane-Orcutt迭代法
    - 可以通过`prais Y X, corc` 给出rho的估计量，用这个估计的结果进行广义差分
  - 稳健标准误法（Newey-West s.e.）
    - `newey Y X, lag(p)` ，一般而言$p = n^{1/4}$

## 5.2 平稳性

- 平稳性的理解（why 平稳检验）
- 平稳性定义
- 平稳性图示判断（定性）
- 单位根检验
  - Dickey-Fuller Test（DF检验）
  - Augmented Dickey-Fuller Test （ADF检验）
    - `dfuller Y, lags(p) `
    - $p = [12 (T/100)^{1/4}]$
- 单整序列
- 趋势平稳、差分平稳随机过程

## 5.3 协整&误差修正模型（ECM）

- 长期均衡关系、协整关系概念
- 协整检验
  - 两变量：Engle-Granger检验（EG检验）
    - 考虑${x_t,y_t}$的（1阶）协整关系，假设H0关系存在，则有$z_t := y_t - \theta x_t$
    - 进行回归：$y = \phi + \theta x_t + z_t $ 其中$\phi, \theta$通过ols即可估计，故$z_t = y_t - \hat\phi - \hat\theta x_t$
    - 再检验$z_t$是否是平稳的即可
  - 多变量：扩展的E-G检验
  - 高阶单整变量的E-G检验
- 协整与均衡的讨论
- 误差修正模型
  - 模型引入
  - 模型概念定义
  - 模型建立：Engle-Granger 两步法

## 5.4 Granger因果检验

- ARMA模型
  - 模型定义
  - 平稳条件
  - 模型识别
    - 定阶：ACP、PACF
    - 参数估计：CLS等
  - 自回归分布滞后模型（ADL）
- VAR模型
  - 模型定义
  - 模型的估计
  - 模型的局限性
  - 结构向量自回归（SVAR）模型
- Granger因果检验
  - 检验原理
    - Granger只适用于平稳/协整的序列
  - 检验模型表述
  - 检验结果分析
  - 实证应用中的讨论
  - STATA：
    - 首先需要用ADF检验的平稳性
    - 其次通过`varsoc Y X, maxlag()` 来定阶p
    - 根据p进行VAR估计，`var Y X, lags(p)`
    - 根据估计结果进行`vargranger`
    - 通过`varlmar,mlag()` 用l-m检验残差序列的相关性

# 6. 非截面数据模型

## 6.1 选择性样本模型

- 截断（truncation）问题
- 归并（censoring）问题

## 6.3 固定效应面板数据

- 面板数据模型概述
  - 固定效应模型和随机效应模型
  - 面板模型
    1. 截面个体**变系数模型**
    2. 截面个体**变截距模型**
    3. 截面个体**截距、系数不变**
    4. 截面个体**不变截距、变系数模型**
    5. 时点变系数模型
    6. 截面个体和时点
- 模型的设定检验
  - 检验目的
    - F检验
- **固定效应变截距模型【重点】**
  - 最小二乘虚拟变量模型、参数估计
  - 固定效应模型的组内估计
  - 实证
    - 仅控制截面个体效应的固定效应变截距模型
    - 同时控制截面个体效应和时点效应的固定效应变截距模型
    - 混合模型
- 固定效应变系数模型
  - 实证中变系数问题
  - 模型表达
  - 截面个体不相关的模型估计
  - 截面个体相关的模型估计
  
    
  
    
