#import "@preview/touying:0.6.1": *
#import themes.simple: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.4" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.4.1": *
#import "@preview/mitex:0.2.5": *
#import "@preview/equate:0.3.2": *

#set-zero-fill(true)
#set-leading-zero(true)
#set-theorion-numbering("1")

#import cosmos.clouds: *
#show: show-theorion
#set-inherited-levels(0)

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)
#show: equate.with(breakable: true, sub-numbering: false)
#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-common(frozen-counters: (theorem-counter,), show-notes-on-second-screen: none),  // freeze theorem counter for animation
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#set text(
  font: (
    "Libertinus Serif",
    "Noto Serif CJK SC",
  ),
  cjk-latin-spacing: auto,
  size: 20pt
)

#show ref: it => {
  let eq = math.equation
  let el = it.element
  // Skip all other references.
  if el == none or el.func() != eq { return it }
  // Override equation references.
  link(el.location(), numbering(
    el.numbering,
    ..counter(eq).at(el.location())
  ))
}

#let restate-equation(target) = context {
  let results = query(
    selector(target)
  )
  text(results.first())
}

#title-slide[
  #heading(level: 1, outlined: false, numbering: none)[Asymptotic Analysis]
  #v(2em)

  Samuka007

  Nov 8
]

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

#let pop-loss-diff = $L lr((hat(theta)), size: #50%) - L lr((theta^*), size: #50%)$

= Background - Supervised Learning Formulation

== Supervised learning
#slide[
  === Problem setup
  #set math.equation(numbering: none)
  Suppose we have inputs from input space $cal(X)$ and labels belong to the output 
  space $cal(Y)$. Suppose we are interested in a specific joint probability 
  distribution $P$ over $cal(X) times cal(Y)$, from which we can draw i.i.d. samples
  ${(x^((i)), y^((i)))}^n_(i=1) ~ P$. 

  The goal of supervised learning is to learn a 
  mapping from $cal(X)$ to $cal(Y)$ using these samples. Such a mapping 
  $h: cal(X) -> cal(Y)$ is called a _predictor_ (also _hypothesis_ or _model_).

  We measure the quality of a predictor $h$ using a _loss function_. Here we define 
  a loss function $cal(l): cal(Y) times cal(Y) -> RR$, where the two arguments are 
  the true label $y$ and the predicted label $hat(y)$ respectively, and give a 
  number that captures how different the two labels are. We assume $cal(l)(hat(y), y) >= 0$.
  Then, the loss of a _model_ $h$ on an example $(x, y)$ is defined as $cal(l)(h(x), y)$.
]

#slide[
  === Risk definitions
  The _population risk_ (also _expected risk_ or _true risk_) of a predictor $h$ is 
  defined as the expected loss over the data distribution:
  $ L(h) =^triangle limits(EE)_((x,y)~P) [cal(l)(h(x), y)] $

  *Hypothesis class.* In practice, we often restrict our attention within a more 
  constrained set of predictors $cal(H)$, called the _hypothesis family_ (or 
  _hypothesis class_), which we know how to optimize over. 

  For one $h in cal(H)$, we define the _excess risk_ of $h$  with respect to $cal(H)$ as
  the difference between its population risk and the minimum population risk within $cal(H)$:
  $ L(h) - inf_(g in cal(H)) L(g) $
]

#slide[
  === Parameterization
  By parameterizing the hypothesis class $cal(H)$ using a set of parameters 
  $theta in Theta$, we can write predictors as $h_theta$ for some $theta in Theta$,
  making it explicit. An example of such parameterization of the hypothesis class is 
  $cal(H) = {h: h_theta (x) = theta^top x, theta in RR^d}$.
]

== Empirical risk minimization (ERM)

#slide[
  Our goal is to minimize population risk.
  - We only have a _training set_ of _n_ data points
  - We cannot compute population risk directly
  - We can compute _empirical risk_, the loss over the training set
  - We try to minimize empirical risk instead, i.e. empirical risk minimization (ERM)
  Define the empirical risk of a model $h$ as:
  $ 
  hat(L)(h) 
    = 1/n sum_(i=1)^n cal(l)(h_theta (x^((i))), y^((i))) 
    = 1/n sum_(i=1)^n cal(l)((x^((i)), y^((i))), theta)
  $
  _Empirical risk minimization_ is the method of finding minimizer $hat(theta)$ of $hat(L)$:
  $ hat(theta) in "argmin"_(theta in Theta) hat(L)(h_theta) $
]

#slide[
  #speaker-note[
    This is one reason why it makes sense to use empirical risk: 
    it is an unbiased estimator of the population risk. 
    
    The key question that we seek to answer in the first part of this course is: 
    what guarantees do we have on the excess risk for the parameters learned by 
    ERM? The hope with ERM is that minimizing the training error will lead to small 
    testing error. One way to make this rigorous is by showing that the ERM minimizer's 
    excess risk is bounded.
  ]
  Since we are assuming that our training examples are drawn from the same 
  distribution as the whole population, we know that empirical risk and 
  population risk are equal in _expectation_ (over the randomness of the 
  training dataset).
  $
    limits(EE)_((x^(i), y^((i))) ~^"iid" P) [hat(L)(h_theta)] 
      &= limits(EE)_((x^(i), y^((i))) ~^"iid" P) [1/n sum_(i=1)^n cal(l)(h_theta (x^((i))), y^((i)))] \
      &= 1/n sum_(i=1)^n limits(EE)_((x^(i), y^((i))) ~^"iid" P) [cal(l)(h_theta (x^((i))), y^((i)))] \
      &= 1/n dot n dot limits(EE)_((x^(i), y^((i))) ~^"iid" P) [cal(l)(h_theta (x), y)] \
      &= L(h_theta).
  $
]

= Theorem

== Asymptotics of empirical risk minimization

#set math.equation(numbering: "(1)")
For the asymptotic analysis of ERM, we would like to prove that excess risk is bounded as shown below:
$ L lr((hat(theta)), size: #50%) - inf_(theta in Theta) L(theta) <= c/n + o(1/n) $ <eq:erm-bound>

// #mitex(`
// L( \hat{\theta} ) - \inf_{\theta \in \Theta} L(\theta) \leq \frac{c}{n} + o\left(\frac{1}{n}\right)
// `)

#speaker-note[
  + This is a speaker note.
  + You won't see it unless you use `config-common(show-notes-on-second-screen: right)`
]

#align(center + horizon)[
  #theorem()[
    Suppose that\ 
    (a) $hat(theta)$ as $n -> infinity$ (i.e. consistency of $hat(theta)$), \
    (b) #mi(`\nabla^2 L(\theta^*)`) is full rank, and \
    (c) other appropriate regularity conditions hold.

    #colbreak()

    Then,

    #block[1. $sqrt(n)(hat(theta) - theta^*) = O_P (1)$.] <thm:erm-asymp-1>

    #block[2. $sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1))$.] <thm:erm-asymp-2>

    #block[3. $n(#pop-loss-diff) = O_P (1)$.] <thm:erm-asymp-3>

    #block[4. $n(#pop-loss-diff) ->^d 1/2 norm(S)^2_2 "where" \
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2))$.] <thm:erm-asymp-4>
    
    #block[5. $lim_(n -> infinity) EE [n(#pop-loss-diff)] = 1/2tr(nabla^2 L(theta^*)^(-1) "Cov"(nabla cal(l)((x,y), theta^*)))$.] <thm:erm-asymp-5>
  ] <thm:erm-asymp>
]

== Key ideas of the proof

#slide[
  #set math.equation(numbering: none)
  We will prove the theorem above by applying the following main ideas:

  + Obtain an expression for the excess risk by Taylor expansion of the derivative of the empirical risk $nabla hat(L)(theta)$ around $theta^*$.

  + By _the law of large numbers_, as $n -> infinity$ we have

    $ hat(L)(theta) ->^p L(theta) $
    $ nabla hat(L) (theta) ->^p nabla L(theta) $
    $ nabla^2 hat(L) (theta) ->^p nabla^2 L(theta) $

  + Central limit theorem (CLT).
]

#centered-slide[
  #speaker-note[
    所以一旦我们能够证明 $sqrt(n)(hat(X) - EE(X)) ->^d cal(N)(0, Sigma)$，他就满足定理的第一部分和第二部分。
  ]
  #theorem(title: "Central Limit Theorem")[
    #set math.equation(numbering: none)
    Let $X_1, X_2, dots, X_n$ be i.i.d. random variables, where $hat(X) = 1/n sum_(i=1)^n X_i$ and $Sigma$ is finite. Then, as $n -> infinity$ we have
    $ hat(X) ->^p EE(X) $
    $ sqrt(n)(hat(X) - EE(X)) ->^d cal(N)(0, Sigma) $
    i.e.
    $ sqrt(n)(hat(X) - EE(X)) = O_P (1) $
  ] <thm:clt-iid>
]

= Main proof （一般形式）

== Proof of part 1 & 2
#slide[
  #speaker-note[
    - 我们希望将 $hat(theta)$ 与 $theta^*$ 进行比较，因此我们考虑在 $theta^*$ 附近对 $nabla hat(L)(theta)$ 进行泰勒展开。
    - 由于 $hat(theta)$ 是经验风险的极小值点，我们有 $nabla hat(L)(hat(theta)) = 0$。
  ]

  _*Proof.*_ By definition, $hat(theta)$ minimizes the empirical risk, so we have $nabla hat(L)(hat(theta)) = 0$.
  We perform a Taylor expansion of $nabla hat(L)(theta)$ around $theta^*$:
  $ 
  0 = nabla hat(L)(hat(theta)) = nabla hat(L)(theta^*) + nabla^2 hat(L)(theta^*)(hat(theta) - theta^*) + O(norm(hat(theta) - theta^*)^2_2). 
  $
  Rearranging,
  $
  hat(theta) - theta^* = - (nabla^2 hat(L)(theta^*))^(-1) nabla hat(L)(theta^*) + O(norm(hat(theta) - theta^*)^2_2).
  $
  Multiplying both sides by $sqrt(n)$, we get
  $
  sqrt(n)(hat(theta) - theta^*) &= - (nabla^2 hat(L)(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*) + sqrt(n) O(norm(hat(theta) - theta^*)^2_2) \
    &approx - (nabla^2 L(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*). #<eq:taylor-expansion-rearranged>
  $

]
#slide[
  #theorion-restate(filter: <thm:clt-iid>)
]
#slide[
  #theorem-box(title: "Part 2", outlined: false)[$sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)).$]
  Let $X_i = nabla cal(l)((x_i, y_i), theta^*)$ and $hat(X) = nabla hat(L) (theta^*)$, applying @thm:clt-iid,
  $
    sqrt(n) (nabla hat(L)(theta^*) - EE(nabla hat(L)(theta^*))) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
  Since $EE(nabla hat(L)(theta^*)) = nabla L(theta^*) = 0$, we have
  $
    sqrt(n) (nabla hat(L)(theta^*) - nabla L(theta^*)) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
  and thus
  $
    sqrt(n) nabla hat(L)(theta^*) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))).
  $ <eq:clt-nabla-empirical-risk>
]
#slide[
  #theorem-box(title: "Part 2", outlined: false)[$sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)).$]
  #set math.equation(numbering: none)
  Recall @eq:taylor-expansion-rearranged,
  $
    sqrt(n)(hat(theta) - theta^*) approx - (nabla^2 L(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*).
  $
  From @eq:clt-nabla-empirical-risk,
  $
    sqrt(n) nabla hat(L)(theta^*) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))).
  $

  #set math.equation(numbering: "(1)")
  By _the law of large numbers_, $nabla^2 hat(L)(theta^*) ->^d nabla^2 L(theta^*)$,
  $ 
    sqrt(n)(hat(theta) - theta^*) 
      &->^d nabla^2 L(theta^*)^(-1) cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
]

#slide[
  #lemma[
    If $Z ~ cal(N) (0, Sigma)$ and $A$ is a deterministic matrix, then $A Z ~ cal(N)(0, A Sigma A^top)$.
  ] <lem:slutsky-1>
  With an application of Slutsky's theorem // WTF is Slutsky theorem?
  $ 
    sqrt(n)(hat(theta) - theta^*) 
      &->^d nabla^2 L(theta^*)^(-1) cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))) #<equate:revoke> \
      &=^d cal(N)(0, (nabla^2L(theta^*))^(-1) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)) \
    // sqrt(n)(hat(theta) - theta^*) &= O_P (1)
  $
  #theorem-box(title: "Part 1", outlined: false)[$sqrt(n)(hat(theta) - theta^*) &= O_P (1)$]
  Part 1 follows directly from Part 2 by the following fact: If $X_n ->^d X$ for some probability distribution $P$, then $X_n = O_P (1)$.
]

== Proof of part 3 & 4

#slide[
  #speaker-note[
    We now turn to proving Parts 3 and 4.
    - 再次对 $L(hat(theta))$ 在 $theta^*$ 附近进行泰勒展开。
    - 为了使用 Part 1 & 2 中的结论，我们整理等式后乘上 $n$，将 $hat(theta) - theta^*$ 转化为 $sqrt(n)(hat(theta) - theta^*)$ 处理。
    - 在 @eq:trans-def-before 中，根据定义，由于 $L(hat(theta)) - L(theta^*) >= 0$ ，右边处理完是个非负的二次型，那么这个 Hassian 矩阵也是半正定的，所以可以右边将写成范数平方的形式，即 @eq:trans-def-after。
  ]
  #theorem-box(title: "Part 4", outlined: false)[$n(L(hat(theta)) - L(theta^*)) ->^d 1/2 norm(S)^2_2$ where
    $
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2)) #<equate:revoke>
    $
  ]
  Using a Taylor expansion of $L$ with respect to $theta$ around $theta^*$, we find
  $
    L(hat(theta)) &= L(theta^*) + 
      chevron.l underbrace(nabla L(theta^*), 0), hat(theta) - theta^* chevron.r \ 
      &+ 1/2 (hat(theta) - theta^*)^top nabla^2 L(theta^*) (hat(theta) - theta^*) + 
      o(norm(hat(theta) - theta^*)^2_2).
  $
  For minimizer $theta^*$, we have $nabla L(theta^*) = 0$. Rearranging and multiplying both sides by $n$, we get
]

#slide[
    #theorem-box(title: "Part 4", outlined: false)[$n(L(hat(theta)) - L(theta^*)) ->^d 1/2 norm(S)^2_2$ where
    $
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2)) #<equate:revoke>
    $
  ]
  For minimizer $theta^*$, we have $nabla L(theta^*) = 0$. Rearranging and multiplying both sides by $n$, we get
  $
    n(#pop-loss-diff) 
      &= n/2 chevron.l hat(theta) - theta^*, nabla^2 L(theta^*) (hat(theta) - theta^*) chevron.r + o(norm(hat(theta) - theta^*)^2_2) #<eq:taylor-expansion-risk> \
      &approx 1/2 chevron.l underbrace(sqrt(n)(hat(theta) - theta^*), v), underbrace(nabla^2 L(theta^*) sqrt(n)(hat(theta) - theta^*), A v) chevron.r #<eq:trans-def-before> \
      &= 1/2 norm(nabla^2 L(theta^*)^(1/2) sqrt(n)(hat(theta) - theta^*))^2_2, #<eq:trans-def-after> \
  $
]

#slide[
  #speaker-note[
    By Part 2, we know the asymptotic distribution of $sqrt(n)(hat(theta) - theta^*)$ is Gaussian.
  ]
  Let 
  $ 
    S = nabla^2 L(theta^*)^(1/2) underbrace(sqrt(n)(hat(theta) - theta^*), "Gaussian" v),
  $
  i.e. the random vector inside the norm. As $n -> oo$, we have $n(#pop-loss-diff) ->^d 1/2 norm(S)^2_2$, where
  #theorem-box[
    $
      S &~ nabla^2 L(theta^*)^(1/2) cal(N)(0, nabla^2 L(theta^*)^(-1) "Cov"(nabla cal(l)((x,y), theta^*))nabla^2L(theta^*)^(-1)) \
        &= cal(N)(0, nabla^2L(theta^*)^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*))nabla^2 L(theta^*)^(-1/2)).
    $
    and thus $n(#pop-loss-diff) = O_P (1)$.
  ]
  // #theorion-restate(filter: <lem:slutsky-1>)
]

== Proof of part 5

#slide[
  Since $EE(S) = 0$, and using the feature that the trace operator is invariant under cyclic permutations, and some regularity conditions,
  $
    lim_(n->oo) EE[n(#pop-loss-diff)]
      &= 1/2 EE[norm(S)^2_2] = 1/2 EE[tr(S^top S)] \ 
      &= 1/2 EE[tr(S S^top)] = 1/2 tr(EE[S S^top]) \
      &= 1/2 tr("Cov"(S)) \
      &= 1/2 tr(nabla^2 L(theta^*)^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*)) nabla^2 L(theta^*)^(-1/2)) \
      &= 1/2 tr(nabla^2 L(theta^*)^(-1) "Cov"(nabla cal(l)((x,y), theta^*))).
  $
]

= Well-specified case

#slide[
  #speaker-note[
    Assume that we performing  maximum likelihood estimation (MLE)
  ]
  #theorem[
    In addition to the assumptions of @thm:erm-asymp, suppose there exists a parametric model $P(y mid(|) x; theta ), theta in Theta$, such that ${y^((i)) mid(|) x^((i))}^n_(i=1) ~ P(y^((i)) mid(|) x^((i)); theta_*)$ for some $theta_* in Theta$ (i.e. the model is well-specified). Assume the loss function is the negative log-likelihood: $cal(l)((x,y), theta) = - log P(y mid(|) x; theta)$. As before, let $hat(theta)$ and $theta^*$ denote the minimizers of the empirical risk and population risk respectively. Then
    $ theta^* = theta_* $ <eq:well-specified-param>
    $ EE[nabla cal(l)((x,y), theta^*)] = 0 $ <eq:well-specified-mean-zero>
    $ "Cov"(nabla cal(l)((x,y), theta^*)) = nabla^2 L(theta^*) $ <eq:well-specified-fisher-info>
    $ sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, nabla^2 L(theta^*)^(-1)) $ <eq:well-specified-asymp-dist>
  ]
]

#slide[
  #theorem-box()[
    #restate-equation(<eq:well-specified-asymp-dist>)
  ]
  *_Remark_* You may also have seen @eq:well-specified-asymp-dist in the following form: under the maximum likelihood estimation (MLE) paradigm, the MLE is asymptotically efficient as it achieves the Cramer-Rao lower bound. That is, the parameter error of the MLE estimate converges in distribution to $cal(N)(0, cal(I)(theta)^(-1))$, where $cal(I)(theta)$ is the Fisher information matrix (in this case, equivalent to the risk Hessian $nabla L(theta^*)$.
  #footnote[
    此处Fisher信息矩阵的符号没找到对应的变体
  ]
]

== Proof of @eq:well-specified-param
#slide[
  From the definition of population risk,
  $
    L(theta) 
      &= EE[cal(l)((x,y), theta)] \
      &= EE[-log P(y mid(|) x; theta)] \
      &= EE[-log P(y mid(|) x; theta) + log P(y mid(|) x; theta_*)] + EE[-log P(y mid(|) x; theta_*))] \
      &= EE[log (P(y mid(|) x; theta_*) / P(y mid(|) x; theta))] + EE[-log P(y mid(|) x; theta_*)].
  $
  Notice that the second term is a constant which we will express as $cal(H)(y mid(|) x; theta_*)$. We expand the first term using the tower rule (or law of total expectation):
  $
    L(theta) 
      &= EE_x [EE_(y mid(|) x)[log (P(y mid(|) x; theta_*) / P(y mid(|) x; theta))]] + cal(H)(y mid(|) x; theta_*).
  $
]
#slide[
  #theorem-box()[#restate-equation(<eq:well-specified-param>)]
  The term in the expectation is just the KL divergence between the two probabilities, so
  $
    L(theta) 
      &= EE["KL"(y|x; theta_* mid(||) y|x; theta)] + cal(H)(y mid(|) x; theta_*) \
      &>= cal(H)(y mid(|) x; theta_*).
  $
  since $"KL"$ divergence is always non-negative. Since $theta_*$ makes the KL divergence term zero, it minimizes $L(theta)$ and so $theta_* in "argmin"_theta L(theta)$. However, the minimizer of $L(theta)$ is unique because of consistency, so we must have $"argmin"_theta L(theta) = theta^*$ which proves @eq:well-specified-param.
]

== Proof of @eq:well-specified-mean-zero

#slide[
  #theorem-box[#restate-equation(<eq:well-specified-mean-zero>)]
  For @eq:well-specified-mean-zero, recall $nabla L(theta^*) = 0$, so we have
  $
    0 = nabla L(theta^*) 
      = nabla EE[cal(l)((x^((i)), y^((i))), theta^*)] 
      = EE[nabla cal(l)((x^((i)), y^((i))), theta^*)]
  $
  where we can switch the gradient and expectation under some regularity conditions, 
  like in this case the gradient is bounded and integrable.
]

== Proof of @eq:well-specified-fisher-info

#slide[
  #speaker-note[
    - By the Law of Total Expectation (or tower rule), $EE_((x,y))[Z] = EE_x[EE_(y|x)[Z]]$

  ]
  #theorem-box[#restate-equation(<eq:well-specified-fisher-info>)]
  To prove @eq:well-specified-fisher-info, we first expand the RHS using the definition of covariance,
  $
    "Cov"(nabla cal(l)((x,y), theta^*)) 
      &= EE[nabla cal(l)((x,y), theta^*) nabla cal(l)((x,y), theta^*)^top] \
      &= EE_(x)[EE_(y|x)[nabla cal(l)((x,y), theta^*) nabla cal(l)((x,y), theta^*)^top]]
  $
  express the marginal distributions as integrals
  $
    "Cov"(nabla cal(l)((x,y), theta^*)) 
      &= integral P(x) integral P(y | x; theta^*) (dot) d y d x.
  $
]
#slide[
  And expanding the inner term with the definition of the loss function,
  $
    & "Cov"(nabla cal(l)((x,y), theta^*)) #<equate:revoke> \
    &= integral P(x) (integral P(y | x; theta^*)
      nabla log P(y | x, theta^*) nabla log P(y | x, theta^*)^top d y) d x \
    &= integral P(x) (integral 
        (nabla P(y | x, theta^*) nabla P(y | x, theta^*)^top) / 
        P(y | x; theta^*) 
      d y) d x.
  $
]

#slide[

  Now we expand the LHS using the definition of the population risk:
  $
    nabla^2 L(theta^*)
      = EE[-nabla^2 log P(y | x; theta^*)] \
      = integral P(x) (integral (
        -nabla^2 P(y | x; theta^*) + 
        (nabla P(y | x; theta^*) nabla P(y | x; theta^*)^top) / P(y | x; theta^*)
      ) d y) d x.
  $
  Note that we can express the first term as @eq:integral-zero, thus
  $
    integral nabla^2 P(y | x; theta^*) d y 
      = nabla^2 (integral P(y | x; theta^*) d y) 
      = nabla^2 1 
      = 0.
  $ <eq:integral-zero>

  $
    nabla^2 L(theta^*) 
      = integral P(x) (integral 
        (nabla P(y | x, theta^*) nabla P(y | x, theta^*)^top) / 
        P(y | x; theta^*) 
      d y) d x 
      = "Cov"(nabla cal(l)((x,y), theta^*)) #<equate:revoke>
  $
]

== Proof of @eq:well-specified-asymp-dist
#slide[  
  $
    sqrt(n)(hat(theta) - theta^*) 
      &->^d cal(N)(0, (nabla^2L(theta^*))^(-1) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)) \
      &=^d cal(N)(0, (nabla^2L(theta^*))^(-1) nabla^2 L(theta^*) (nabla^2L(theta^*))^(-1)) \
      &=^d cal(N)(0, nabla^2 L(theta^*)^(-1)). #<equate:revoke>
  $
  Finally, @eq:well-specified-asymp-dist follows directly from @thm:erm-asymp Part 2 by substituting @eq:well-specified-fisher-info. #h(1fr) $qed$
]

== Well-specified case for @eq:erm-bound

#slide[
  #speaker-note[
    - Using similar logic to our proof of Part 4 and 5 of Theorem 2.1,
    - Since a chi-squared distribution with p degrees of freedom is defined as a sum of the squares of p independent standard normals
  ]
  #theorem-box(title: ref(<thm:erm-asymp>) + " Part 4", outlined: false)[$n(L(hat(theta)) - L(theta^*)) ->^d 1/2 norm(S)^2_2$ where
    $
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2) "Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2)) #<equate:revoke>
    $
  ]
  #theorem-box[#restate-equation(<eq:well-specified-fisher-info>)]
  In this case we can see that $n(#pop-loss-diff) ->^d 1/2 norm(S)^2_2$ where $S ~ cal(N)(0, I)$.
  #lemma[
    If $Z ~ cal(N)(0, Sigma^(-1))$, and $Z in RR^p$, then $Z^top Sigma Z ~ chi^2(p)$.
  ] <lem:chi-squared>
]
#slide[
  // #theorion-restate(filter: <lem:chi-squared>)
  From @lem:chi-squared, given $theta in RR^d$ and $n -> oo$, we have
  $
    2n(#pop-loss-diff) &->^d norm(S)^2_2 =^d S^top I S ~ chi^2(d)
  $
  Recall our original target @eq:erm-bound,
  #restate-equation(<eq:erm-bound>)
  We can thus characterize the excess risk in this case using the properties of a chi-squared distribution:
  $
    lim_(n -> oo) EE[#pop-loss-diff] = p/(2n).
  $
]

#focus-slide[
  #heading(level: 1, outlined: false, numbering: none)[Thank you!]
]
