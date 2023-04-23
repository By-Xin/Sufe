# 相关性与Copula函数

## 1. 相关性与关联性 

[考察重点]

- 相关概念：相关系数、协方差、独立性、相关性
- 相关性只能描述两个变量之间的线性关系

**EWMA（指数平滑）:**

$$cov_n=\lambda cov_{n-1}+(1-\lambda)x_{n-1}y_{n-1}$$

($cov_n$指的是第n-1天的协方差)

$$cov_{(n)} = \rho_{(n)} \sigma_{x,(n)}\sigma_{y,(n)}$$

$$\sigma_{(n)}^2 = \lambda\sigma_{(n-1)}^2+(1-\lambda)X_{(n-1)}^2$$

**GARCH(1,1) :**
$$cov_{(n)}=\omega+\alpha X_{(n-1)}Y_{(n-1)}+\beta cov_{(n-1)}$$
$$\sigma_{(n)}^2=\omega+\alpha X_{(n-1)}^2+\beta Y_{(n-1)}^2$$

## 2. Copula函数* 

[了解即可]

- Copula函数可以刻画两个变量之间的非线性关系



