# VII: Interest Rate Risk

## 1. Management of Net Interest Income
  
- 一般而言，人们总是倾向于存短贷长，因此需要对不同期限的存贷款利率进行调整，给长期存款更高的利率吸引长期存款，给长期贷款更高的利率压低长期贷款
- 一些利率互换swap衍生品等可以对冲利率风险，但这个操作并没有对冲流动性风险

## 2. 利率种类

### 2.1 国债

- 一年内债券：bills
- 2～10年：notes
- 10年以上：bonds
- 一般认为不会对本币违约
- 国债利率可以认为是$r_f$

### 2.2 LIBOR

- 什么是LIBOR？
  - LIBOR是伦敦银行同业拆借利率（London Interbank Offered Rate）的缩写，是全球最具代表性的利率之一，用于计算各种金融产品的利率，如贷款、抵押贷款、授信额度等。
  - LIBOR的期限包括一天、一周、一个月、三个月、六个月和一年等，每种期限的LIBOR都有不同的利率水平。

- 如何计算LIBOR？
  - LIBOR的计算方式是通过伦敦银行之间的每日报价确定的。
  - 每个银行都会提交他们所认为的可以获得资金的成本。然后，这些报价被汇总，并去除最高和最低的25%的报价，然后计算平均值得出LIBOR。

- LIBOR的作用？
  - LIBOR被广泛用于各种金融合同和金融产品中，如贷款、债券、授信额度、外汇期货等。
  - LIBOR也用于计算一些金融衍生品的价格，如利率互换。
    - 通过利率互换可以将LIBOR展期至一年以外

- LIBOR存在的问题？
  - 最主要的是操纵风险。
  - 在2008年金融危机期间，一些银行被指控在LIBOR报价中操纵利率
  - 监管机构在2012年启动了对LIBOR的改革，包括改变计算方法、增加报告银行、加强监管等

- LIBOR改革的影响？
  - 替代性利率（Alternative Reference Rates）
    - 例如美国的SOFR（Secured Overnight Financing Rate）
    - 欧洲的€STR（Euro Short-Term Rate）

### 2.3 OIS

- 定义
  - 隔夜指数互换（Overnight Index Swap，简称OIS）是一种利率互换工具，用于固定利率和浮动利率之间的转换
  - 它的本质是一种无抵押短期借贷
  - 隔夜利率来自一个由政府组织的银行间拆借市场，在该市场有多余储备金的银行，可以将资金借给储备金不足的银行
  - 基础是隔夜利率，例如美国的Fed Funds Rate和英国的SONIA（Sterling Overnight Index Average）等

- 工作原理
  - 一方支付固定利率，另一方支付浮动利率，浮动利率基于隔夜利率，例如SONIA。
  - 交换发生在互换合同的到期日，交换的金额基于固定利率和浮动利率之间的差额
  - 如果隔夜利率上涨，则支付固定利率的一方将获得收益，反之亦然

- 作用
  - OIS通常被用于避免利率风险，即保护投资者免受利率波动的影响
  - OIS的价格反映了市场对未来隔夜利率的预期，因此，它也被用于作为一种衡量市场情绪的指标

- OIS与LIBOR的区别
  - OIS基于隔夜利率，而LIBOR是银行之间拆借利率的平均值。此外
  - OIS没有信用风险，因为它是无抵押短期借贷，而LIBOR涉及银行之间的信用交易

- OIS-LIBOR价差
  - 重要的风险指标
  - 反映的是一个AA级银行在一定期限内信用风险溢价
  - 通常LIBOR-OLS价差小于10个基点
  - 价差越大说明，对手信用风险可能越大

- OIS的风险
  - OIS没有信用风险
  - 存在市场风险和流动性风险
    - 例如，在金融危机期间，OIS价格的波动性增加，反映了市场对流动性的担忧
  - 由于OIS的价格反映市场情绪，因此它也受到市场波动和情绪变化的影响

- OIS的市场规模
  - OIS是一个庞大的市场，其规模约为17万亿美元
  - 被广泛用于各种金融产品和交易中，例如外汇衍生品、债券和股票衍生品等

- OIS的监管
  - OIS是由各国的金融监管机构监管的
    - 例如，在美国，OIS交易是由商品期货交易委员会（CFTC）监管的

### 2.4 回购利率

### 2.5 无风险利率

## 3. 债券定价

- 债券的价格为其所有现金流的折现现值，记$B$为理论债券价格，$y$为预期收益率，$T$为期限，$c$为每年支付利息，$N$为面值
$$\begin{aligned}
B & =c \times e^{-y \times 1}+c \times e^{-y \times 2}+c \times e^{-y \times 3}+\cdots+N \times e^{-y \times T} \\
& =\sum_{t=1}^T c \times e^{-y \times t}+N \times e^{-y \times T}
\end{aligned}$$
- 每年支付利息为票面价值乘以票息率
$$c = N \times r$$

## 4. 久期与凸度

### 4.1 久期

#### Macaulay Duration

- 定义久期为债券价格随着预期收益率的变化而变化的幅度：
$$D = -\frac{1}{B}\frac{\partial B}{\partial y}$$
- 由上式有如下等价线性近似：
$$\frac{\Delta B}{B}=-D\Delta y$$ 即债券价格变化的百分比近似等于久期乘利率的变化幅度（同时由债券的性质可以知道，利率升高，债券价格下降，因此是负向相关的）
- 如果将债券的定价公式代入$B$中，则有
$$D=-\frac{1}{B} \frac{\mathrm{d}\left(\sum_{i=1}^n c_i e^{-y t_i}\right)}{\mathrm{d} y}=\sum_{i=1}^n t_i \frac{c_i e^{-y t_i}}{B} ~\ast$$ 可以认为久期是偿还时间关于每次支付现金流的折现，或者可以认为久期就是在折现意义上多久可以收回本金的测定
- 久期可以用来衡量债券价格对收益率变动的敏感度，即当市场收益率变动时，债券价格会发生多大的变化
- 一般来说，久期越长，债券价格对收益率变动的敏感度越大，因为较长的久期意味着更多的现金流量需要等待
- 对于一个零息债券，久期即为其到期时间

#### Modified Duration
  
- Macaulay 久期的定义（$\ast$式）是根据连续复利得到的，若对于非连续复利，可以做如下修正：
- 一年一次复利
$$D^*=\frac{D}{1+y} \quad \Delta B \approx-D^* B \Delta y \quad \frac{\Delta B}{B} \approx-D^* \Delta y$$
- 一年$m$次
$$D^*=\frac{D}{1+y/m}$$

#### Absolute Duration

$$D_\$=-\frac{\partial B}{\partial y}$$

- 类似于delta

### 4.2 凸性

#### Convexity

- 定义凸度为二阶导
$$\begin{aligned}
&C=\frac{1}{B} \frac{\mathrm{d}^2 B}{\mathrm{~d} y^2}=\sum_{i=1}^n t_i{ }^2 \frac{c_i e^{-y t_i}}{B}\\
&\frac{\Delta B}{B} \approx-D \Delta y+\frac{1}{2} C(\Delta y)^2
\end{aligned}$$
- 债券收益率变化较大时，凸性计算比久期计算更精确

#### Absolute Convexity

$$C_\$=-\frac{\partial^2 B}{\partial y^2}$$

- 类似于gamma